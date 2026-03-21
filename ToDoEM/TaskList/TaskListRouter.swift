import UIKit

protocol TaskListRouterProtocol {
    func navigateToTaskDetail(from view: UIViewController, task: Task)
}

class TaskListRouter: TaskListRouterProtocol {
    
    func navigateToTaskDetail(from view: UIViewController, task: Task) {
        let detailVC = TaskDetailBuilder.build(task: task)
        view.navigationController?.pushViewController(detailVC, animated: true)
    }
}
