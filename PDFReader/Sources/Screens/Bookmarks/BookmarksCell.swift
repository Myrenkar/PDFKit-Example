import UIKit

final class BookmarksCell: CollectionViewCell {
    // MARK: - Subviews
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private(set) lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    
    // MARK: - Setup
    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        [imageView, nameLabel].forEach(contentView.addSubview)
    }

    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
