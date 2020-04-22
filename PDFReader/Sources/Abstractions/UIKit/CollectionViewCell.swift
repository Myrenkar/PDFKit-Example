import UIKit

class CollectionViewCell: UICollectionViewCell, Reusable {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupProperties()
        setupViewHierarchy()
        setupLayoutConstraints()
    }

    @available(*, unavailable, message: "Use init(frame:) instead")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Abstract
    /// Sets up the properties of `self`. Called automatically on `init(frame:)`.
    func setupProperties() {
        // no-op by default
    }

    /// Sets up self views hierarchy and subviews in `self`. Called automatically on `init(frame:)`.
    func setupViewHierarchy() {
        // no-op by default
    }

    /// Sets up layout in `self`. Called automatically on `init(frame:)`.
    func setupLayoutConstraints() {
        // no-op by default
    }

}
