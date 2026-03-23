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

    init(storage: StorageServiceProtocol, network: NetworkServiceProtocol) {
        self.storage = storage
        self.network = network
    }

    // MARK: - TaskListInteractorInput

    func fetchTasks() {
        let stored = storage.fetchTasks()
        if stored.isEmpty {
            // Первый запуск — грузим из API, сохраняем в CoreData
            network.fetchTodos { [weak self] apiTasks in
                guard let self else { return }
                apiTasks.forEach { self.storage.addTask($0) }
                self.output?.didFetchTasks(self.storage.fetchTasks())
            }
        } else {
            output?.didFetchTasks(stored)
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
        storage.addTask(task)
        return task
    }

    func deleteTask(id: Int) {
        storage.deleteTask(id: id)
        output?.didFetchTasks(storage.fetchTasks())
    }

    func toggleTask(id: Int) {
        var tasks = storage.fetchTasks()
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].isCompleted.toggle()
        storage.updateTask(tasks[index])
        output?.didFetchTasks(storage.fetchTasks())
    }

    func updateTask(_ task: TaskModel) {
        storage.updateTask(task)
        output?.didFetchTasks(storage.fetchTasks())
    }
}
