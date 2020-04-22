import UIKit

final class TableOfContentCell: TableViewCell {
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setupProperties() {
        backgroundColor = .white
    }

    override func setupViewHierarchy() {
        contentView.addSubview(resultLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if indentationLevel == 0 {
            resultLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        } else {
            resultLabel.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }

    override func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            resultLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
