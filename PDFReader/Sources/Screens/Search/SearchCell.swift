import UIKit

final class SearchCell: TableViewCell {
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
    
    
    override func setupProperties() {
        backgroundColor = .white
    }
    
    override func setupViewHierarchy() {
        contentView.addSubview(resultLabel)
        contentView.addSubview(pageNumberLabel)
    }
    
    override func setupLayoutConstraints() {
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
