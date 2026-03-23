import UIKit

// MARK: - Protocols

protocol TaskListPresenterInput: AnyObject {
    func viewDidLoad()
    func didTapAddButton()
    func didToggleTask(id: Int)
    func didDeleteTask(id: Int)
    func didSelectTask(_ task: TaskModel)
    func didShareTask(_ task: TaskModel)
}

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskModel])
}

// MARK: - Presenter

final class TaskListPresenter: TaskListPresenterInput {

    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorInput!
    var router: TaskListRouterProtocol!

    // MARK: - TaskListPresenterInput

    func viewDidLoad() {
        interactor.fetchTasks()
    }

    func didTapAddButton() {
        // Создаём пустую задачу и сразу открываем редактор
        let newTask = interactor.addNewTask()
        router.navigateToTaskDetail(task: newTask) { [weak self] updated in
            self?.interactor.updateTask(updated)
        }
        interactor.fetchTasks()
    }

    func didToggleTask(id: Int) {
        interactor.toggleTask(id: id)
    }

    func didDeleteTask(id: Int) {
        interactor.deleteTask(id: id)
    }

    func didSelectTask(_ task: TaskModel) {
        router.navigateToTaskDetail(task: task) { [weak self] updated in
            self?.interactor.updateTask(updated)
        }
    }

    func didShareTask(_ task: TaskModel) {
        router.showShareSheet(task: task)
    }
}

// MARK: - TaskListInteractorOutput

extension TaskListPresenter: TaskListInteractorOutput {
    func didFetchTasks(_ tasks: [TaskModel]) {
        view?.showTasks(tasks)
    }
}
