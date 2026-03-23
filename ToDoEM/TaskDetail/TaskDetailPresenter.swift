import Foundation

// MARK: - Protocols

protocol TaskDetailPresenterInput: AnyObject {
    func viewDidLoad()
    func viewWillDisappear(title: String, description: String)
}

protocol TaskDetailViewProtocol: AnyObject {
    func showTask(_ task: TaskModel)
}

// MARK: - Presenter

final class TaskDetailPresenter: TaskDetailPresenterInput {

    weak var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorInput!
    var router: TaskDetailRouterProtocol!
    var task: TaskModel!

    // MARK: - TaskDetailPresenterInput

    func viewDidLoad() {
        view?.showTask(task)
    }

    func viewWillDisappear(title: String, description: String) {
        var updated = task!
        updated.title = title
        updated.description = description
        interactor.saveTask(updated)
    }
}
