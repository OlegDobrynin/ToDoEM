import UIKit

protocol TaskDetailRouterProtocol {
    func navigateToTaskList(from view: UIViewController)
}

class TaskDetailRouter: TaskDetailRouterProtocol {
    
    func navigateToTaskList(from view: UIViewController) {
        let listVC = TaskListBuilder.build()
        view.navigationController?.pushViewController(listVC, animated: true)
    }
}
