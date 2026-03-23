import UIKit

final class TaskListBuilder {

    static func build(
        storage: StorageServiceProtocol,
        network: NetworkServiceProtocol
    ) -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()
        let interactor = TaskListInteractor(storage: storage, network: network)

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

        router.viewController = view

        return view
    }
}
