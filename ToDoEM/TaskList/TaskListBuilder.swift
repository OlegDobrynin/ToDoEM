import UIKit

class TaskListBuilder {
    
    static func build() -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        
        return view
    }
}
