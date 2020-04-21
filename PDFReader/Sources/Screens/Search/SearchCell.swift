import UIKit

final class SearchCell: UITableViewCell, Reusable {
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewHierarchy()
        setupProperties()
        setupLayoutConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperties() {
        backgroundColor = .white
    }

    func setupViewHierarchy() {
        contentView.addSubview(resultLabel)
        contentView.addSubview(pageNumberLabel)
    }

    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            resultLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),

            pageNumberLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            pageNumberLabel.topAnchor.constraint(equalTo: resultLabel.layoutMarginsGuide.bottomAnchor, constant: 8),
            pageNumberLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
