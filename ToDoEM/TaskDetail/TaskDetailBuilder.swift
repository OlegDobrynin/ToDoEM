import UIKit

class TaskDetailBuilder {
    
    static func build(task: Task) -> UIViewController {
        let view = TaskDetailViewController()
        let presenter = TaskDetailPresenter()
        let router = TaskDetailRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.task = task
        
        return view
    }
}
