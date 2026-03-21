import UIKit

protocol TaskDetailPresenterProtocol {
    func backButtonTapped()
}

class TaskDetailPresenter: TaskDetailPresenterProtocol {
     
    var router: TaskDetailRouterProtocol?
    weak var view: UIViewController?
    var task: Task?
    
    func backButtonTapped() {
        guard let view = view else { return }
        router?.navigateToTaskList(from: view)
    }
}
