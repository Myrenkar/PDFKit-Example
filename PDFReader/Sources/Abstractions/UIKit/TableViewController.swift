import UIKit

class TableViewController: UITableViewController {

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProperties()
        setupBindings()
        setupNavigationItem()
    }

    // MARK: - Setup

    /// Sets up the views properties of `self`. Called automatically on `init()`
    func setupProperties() {}

    /// Sets up the bindings of `self`. Called automatically on `init()`
    func setupBindings() {}

    /// Sets up the navigation item of `self`. Called automatically on `init()`
    func setupNavigationItem() {}

    // MARK: - Unavailable

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
