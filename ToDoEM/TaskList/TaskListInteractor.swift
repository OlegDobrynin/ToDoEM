import Foundation

// MARK: - Protocols

protocol TaskListInteractorInput {
    func fetchTasks()
    func addNewTask() -> TaskModel
    func deleteTask(id: Int)
    func toggleTask(id: Int)
    func updateTask(_ task: TaskModel)
}

protocol TaskListInteractorOutput: AnyObject {
    func didFetchTasks(_ tasks: [TaskModel])
}

// MARK: - Interactor

final class TaskListInteractor: TaskListInteractorInput {

    weak var output: TaskListInteractorOutput?

    private let storage: StorageServiceProtocol
    private let network: NetworkServiceProtocol
    private let workerQueue = DispatchQueue(label: "worker", qos: .userInitiated)

    init(storage: StorageServiceProtocol, network: NetworkServiceProtocol) {
        self.storage = storage
        self.network = network
    }

    // MARK: - TaskListInteractorInput

    func fetchTasks() {
        workerQueue.async { [weak self] in
            guard let self else { return }
            let stored = self.storage.fetchTasks()
            if stored.isEmpty {
                // Первый запуск — грузим из API, сохраняем в CoreData
                self.network.fetchTodos { [weak self] apiTasks in
                    guard let self else { return }
                    self.workerQueue.async {
                        apiTasks.forEach { self.storage.addTask($0) }
                        let updated = self.storage.fetchTasks()
                        DispatchQueue.main.async {
                            self.output?.didFetchTasks(updated)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.output?.didFetchTasks(stored)
                }
            }
        }
    }

    /// Создаёт пустую задачу в CoreData и возвращает её для открытия в редакторе
    func addNewTask() -> TaskModel {
        let task = TaskModel(
            id: Int(Date().timeIntervalSince1970),
            title: "",
            description: "",
            createdAt: Date(),
            isCompleted: false
        )
        workerQueue.async { [weak self] in
            guard let self else { return }
            self.storage.addTask(task)
            let updated = self.storage.fetchTasks()
            DispatchQueue.main.async {
                self.output?.didFetchTasks(updated)
            }
        }
        return task
    }

    func deleteTask(id: Int) {
        workerQueue.async { [weak self] in
            guard let self else { return }
            self.storage.deleteTask(id: id)
            let updated = self.storage.fetchTasks()
            DispatchQueue.main.async {
                self.output?.didFetchTasks(updated)
            }
        }
    }

    func toggleTask(id: Int) {
        workerQueue.async { [weak self] in
            guard let self else { return }
            var tasks = self.storage.fetchTasks()
            guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
            tasks[index].isCompleted.toggle()
            self.storage.updateTask(tasks[index])
            let updated = self.storage.fetchTasks()
            DispatchQueue.main.async {
                self.output?.didFetchTasks(updated)
            }
        }
    }

    func updateTask(_ task: TaskModel) {
        workerQueue.async { [weak self] in
            guard let self else { return }
            self.storage.updateTask(task)
            let updated = self.storage.fetchTasks()
            DispatchQueue.main.async {
                self.output?.didFetchTasks(updated)
            }
        }
    }
}
