import UIKit

final class TaskDetailViewController: UIViewController {

    var presenter: TaskDetailPresenterInput!

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let titleTextField = UITextField()
    private let dateLabel = UILabel()
    private let contentTextView = UITextView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(
            title: titleTextField.text ?? "",
            description: contentTextView.text ?? ""
        )
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .emBlack

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        titleTextField.placeholder = "Заголовок"
        titleTextField.font = .systemFont(ofSize: 34, weight: .bold)
        titleTextField.textColor = .emWhite
        titleTextField.returnKeyType = .next
        titleTextField.delegate = self

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .emWhite
        dateLabel.alpha = 0.5

        contentTextView.font = .systemFont(ofSize: 16)
        contentTextView.textColor = .emWhite
        contentTextView.backgroundColor = .emBlack
        contentTextView.isScrollEnabled = false
        contentTextView.textContainerInset = .zero
        contentTextView.textContainer.lineFragmentPadding = 0

        view.addSubview(scrollView)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(contentTextView)

        [scrollView, titleTextField, dateLabel, contentTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

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

            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}


// MARK: - Actions

extension TaskDetailViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension TaskDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return false
    }
}

// MARK: - TaskDetailViewProtocol

extension TaskDetailViewController: TaskDetailViewProtocol {
    func showTask(_ task: TaskModel) {
        titleTextField.text = task.title
        contentTextView.text = task.description

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: task.createdAt)
    }
}
