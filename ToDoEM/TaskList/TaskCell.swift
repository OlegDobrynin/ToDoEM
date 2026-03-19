import UIKit

class TaskCell: UITableViewCell {
    
    // MARK: - UI
    
    private let checkboxButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let textStack = UIStackView()
    private let containerStack = UIStackView()

    var onToggle: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        self.backgroundColor = .emBlack
        selectionStyle = .none
        
        checkboxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkboxButton.tintColor = UIColor(named: "EMYellow")
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .emWhite
        titleLabel.numberOfLines = 1
        
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .emWhite
        descriptionLabel.numberOfLines = 2
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .emWhite
        dateLabel.alpha = 0.5
        
        textStack.axis = .vertical
        textStack.spacing = 4
        
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .top

    }
    
    private func setupLayout() {
        
        contentView.addSubview(containerStack)
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(dateLabel)
        
        containerStack.addArrangedSubview(checkboxButton)
        containerStack.addArrangedSubview(textStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    // MARK: - Configure
    
    func configure(title: String,
                   description: String?,
                   date: Date,
                   isCompleted: Bool) {
        
        titleLabel.attributedText = styledText(title, isCompleted: isCompleted, isTitle: true)
        
        descriptionLabel.text = description
        dateLabel.text = formatDate(date)
        
        let imageName = isCompleted ? "checkmark.circle" : "circle"
        checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkboxButton.tintColor = isCompleted ? .emYellow : .emStroke
        
        if isCompleted {
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
        }
        
    }
    
    // MARK: - Styling
    
    private func styledText(_ text: String,
                            isCompleted: Bool,
                            isTitle: Bool) -> NSAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: isTitle
            ? UIFont.systemFont(ofSize: 16, weight: .medium)
                : UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.emWhite,
            .strikethroughStyle: isCompleted ? NSUnderlineStyle.single.rawValue : 0
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    // MARK: - Date formatter
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
