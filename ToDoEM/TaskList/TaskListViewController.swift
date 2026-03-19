import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = mockTasks[indexPath.row]
        
        cell.configure(
            title: task.title,
            description: task.description,
            date: task.createdAt,
            isCompleted: task.isCompleted
        )
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
   
    // MARK: - Setup
    
    func setupUI() {
        view.backgroundColor = .emBlack
        
        let label = UILabel()
        label.text = "Задачи"
        label.textAlignment = .left
        label.textColor = .emWhite
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
        let textField = searchBar.searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .emBlack
        tableView.separatorColor = .emGray
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        
        let stackView = UIStackView(arrangedSubviews: [label, searchBar, tableView])
        stackView.axis = .vertical
        
        let footer = UIView()
        footer.backgroundColor = .emGray
        
        let titleLabel = UILabel()
        
        titleLabel.text = "\(mockTasks.count) Задач"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .emWhite
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addButton.tintColor = .emYellow
        
        view.addSubview(stackView)
        view.addSubview(footer)
        footer.addSubview(titleLabel)
        footer.addSubview(addButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 56),
            
            searchBar.topAnchor.constraint(equalTo: textField.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            
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
            
            titleLabel.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 49),
            
            addButton.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
}

