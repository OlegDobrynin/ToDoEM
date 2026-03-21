import UIKit

class TaskDetailViewController: UIViewController {
    
    var presenter: TaskDetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .emBlack

        let scrollView = UIScrollView()
        
        let titleTextField = UITextField()
        titleTextField.placeholder = "Заголовок"
        titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
        
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .emWhite
        dateLabel.alpha = 0.5
        dateLabel.text = "2/20/2000"
        
        let contentTextView = UITextView()
        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.textColor = .emWhite
        contentTextView.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
        contentTextView.isScrollEnabled = false
        contentTextView.textContainerInset = .zero
        contentTextView.textContainer.lineFragmentPadding = 0
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(contentTextView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            contentTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
            
        ])
        
    }
}
