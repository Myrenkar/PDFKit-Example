import UIKit

final class PDFToolboxView: View {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, bookmarksButton, directionButton, pageCounter, thumbnailButton, tableOfContentsButton, showBookmarksButton ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private(set) lazy var bookmarksButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Bookmark-N"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var showBookmarksButton: UIButton = {
        let button = UIButton()
        button.setTitle("show", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Search"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var thumbnailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Thumb", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var directionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Grid"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 10)
        return button
    }()

    private(set) lazy var tableOfContentsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "List"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 10)
        return button
    }()

    private(set) lazy var pageCounter: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.70)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        addSubview(stackView)
    }

    override func setupProperties() {
        super.setupProperties()
        backgroundColor = .clear
    }

    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()
        NSLayoutConstraint.activate([
            pageCounter.widthAnchor.constraint(equalToConstant: 48)
        ])

        stackView.constrainEdges(to: self)
    }
}
