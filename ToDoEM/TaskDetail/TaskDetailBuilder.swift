import UIKit

final class TaskDetailBuilder {

    static func build(
        task: TaskModel,
        onUpdate: @escaping (TaskModel) -> Void
    ) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter()
        let interactor = TaskDetailInteractor(onUpdate: onUpdate)
        let router = TaskDetailRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.task = task

        router.viewController = view

        return view
    }
}
