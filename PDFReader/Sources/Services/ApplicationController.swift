import UIKit

final class ApplicationController {

    // MARK: Properties

    private let coordinator: ReaderCoordinator

    // MARK: Initialization

    init(dependencies: ApplicationDependenciesProvider) {
        self.coordinator = ReaderCoordinator(factory: dependencies.pdfViewerFactory)
    }

    // MARK: RootViewController

    private(set) lazy var rootViewController: UINavigationController = {
        return coordinator.rootViewController
    }()

}
