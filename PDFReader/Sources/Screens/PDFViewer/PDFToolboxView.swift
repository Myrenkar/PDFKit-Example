import UIKit

final class PDFToolboxView: View {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, resetButton, directionButton, pageCounter, thumbnailButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private(set) lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private(set) lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = .magenta
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var thumbnailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Thumb", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private(set) lazy var directionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Direction", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 10)
        return button
    }()

    private(set) lazy var pageCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
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
        stackView.constrainEdges(to: self)
    }
}
