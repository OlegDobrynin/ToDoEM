import UIKit

final class TaskListViewController: UIViewController {

    var presenter: TaskListPresenterInput!

    // MARK: - State

    private var allTasks: [TaskModel] = []
    private var tasks: [TaskModel] = []
    private var searchRequestId: Int = 0

    // MARK: - UI

    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let footer = UIView()
    private let countLabel = UILabel()
    private let addButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем список при возврате с экрана редактирования
        presenter.viewDidLoad()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .emBlack

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = .emYellow

        titleLabel.text = "Задачи"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .emWhite
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)

        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        searchBar.delegate = self
        let textField = searchBar.searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .emBlack
        tableView.separatorColor = .emGray
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")

        footer.backgroundColor = .emGray

        countLabel.textAlignment = .center
        countLabel.textColor = .emWhite
        countLabel.font = .systemFont(ofSize: 11)

        addButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addButton.tintColor = .emYellow
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, searchBar, tableView])
        stackView.axis = .vertical

        view.addSubview(stackView)
        view.addSubview(footer)
        footer.addSubview(countLabel)
        footer.addSubview(addButton)

        [titleLabel, searchBar, tableView, stackView,
         footer, countLabel, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 56),

            textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footer.heightAnchor.constraint(equalToConstant: 83),

            countLabel.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: footer.topAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 49),

            addButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: footer.topAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        presenter.didTapAddButton()
    }

    private func updateCount() {
        countLabel.text = "\(tasks.count) Задач"
    }
}

// MARK: - TaskListViewProtocol

extension TaskListViewController: TaskListViewProtocol {
    func showTasks(_ tasks: [TaskModel]) {
        allTasks = tasks
        applyFilter(searchBar.text)
    }
}

// MARK: - UISearchBarDelegate

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        applyFilter(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        applyFilter(nil)
    }
}

// MARK: - Filter helper

private extension TaskListViewController {
    func applyFilter(_ query: String?) {
        searchRequestId += 1
        let requestId = searchRequestId
        let source = allTasks
        let normalizedQuery = query?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let filtered: [TaskModel]
            if let normalizedQuery, !normalizedQuery.isEmpty {
                filtered = source.filter {
                    $0.title.lowercased().contains(normalizedQuery) ||
                    $0.description.lowercased().contains(normalizedQuery)
                }
            } else {
                filtered = source
            }

            DispatchQueue.main.async { [weak self] in
                guard let self, requestId == self.searchRequestId else { return }
                self.tasks = filtered
                self.tableView.reloadData()
                self.updateCount()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskCell", for: indexPath
        ) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(
            title: task.title,
            description: task.description,
            date: task.createdAt,
            isCompleted: task.isCompleted
        )
        cell.onToggle = { [weak self] in
            self?.presenter.didToggleTask(id: task.id)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectTask(tasks[indexPath.row])
    }

    // Контекстное меню при долгом нажатии (iOS 13+, фон блюрится автоматически)
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu(title: "", children: []) }

            let edit = UIAction(
                title: "Редактировать",
                image: UIImage(systemName: "pencil")
            ) { _ in
                self.presenter.didSelectTask(task)
            }

            let share = UIAction(
                title: "Поделиться",
                image: UIImage(systemName: "square.and.arrow.up")
            ) { _ in
                self.presenter.didShareTask(task)
            }

            let delete = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.presenter.didDeleteTask(id: task.id)
            }

            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
}
