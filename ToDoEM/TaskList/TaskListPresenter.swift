import UIKit

protocol TaskListPresenterProtocol {
    func didSelectTask(_ task: Task)
}


class TaskListPresenter: TaskListPresenterProtocol {
    
    var router: TaskListRouterProtocol?
    weak var view: UIViewController?
    
    func didSelectTask(_ task: Task) {
        guard let view = view else { return }
        router?.navigateToTaskDetail(from: view, task: task)
    }
}
