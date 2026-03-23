import UIKit

// MARK: - Protocol

protocol TaskDetailRouterProtocol: AnyObject {
    func navigateBack()
}

// MARK: - Router

final class TaskDetailRouter: TaskDetailRouterProtocol {

    weak var viewController: UIViewController?

    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
