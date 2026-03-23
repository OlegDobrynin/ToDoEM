import UIKit

// MARK: - Protocol

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(task: TaskModel, onUpdate: @escaping (TaskModel) -> Void)
    func showShareSheet(task: TaskModel)
}

// MARK: - Router

final class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: UIViewController?

    func navigateToTaskDetail(task: TaskModel, onUpdate: @escaping (TaskModel) -> Void) {
        let vc = TaskDetailBuilder.build(task: task, onUpdate: onUpdate)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func showShareSheet(task: TaskModel) {
        let text = [task.title, task.description]
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        viewController?.present(activity, animated: true)
    }
}
