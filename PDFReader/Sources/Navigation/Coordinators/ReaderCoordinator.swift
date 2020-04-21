import UIKit
import PDFKit

protocol Coordinating {
    associatedtype RootViewController
    var rootViewController: RootViewController { get }
}

final class ReaderCoordinator: NSObject, Coordinating {
    typealias RootViewController = UINavigationController

    private let factory: PDFViewerFactoryProtocol

    init(factory: PDFViewerFactoryProtocol) {
        self.factory = factory
        super.init()
    }

    lazy var rootViewController: UINavigationController = {
        let viewController = factory.buildDocumentListViewModeController(delegate: self)
        return UINavigationController(rootViewController: viewController)
    }()
}

extension ReaderCoordinator: DocumentListViewModeControllerDelegate {
    func didSelect(document: PDFDocument) {
        let viewController = factory.buildPDFViewerViewController(document: document, delegate: self)
        rootViewController.pushViewController(viewController, animated: true)
    }
}

extension ReaderCoordinator: PDFViewerViewControllerDelegate {
    func didTapSearch(document: PDFDocument) {
        let searchViewController = factory.buildSearchViewController(document: document, delegate: self)
        rootViewController.present(searchViewController, animated: true)
    }
}

extension ReaderCoordinator: SearchViewControllerDelegate {
    func didTapSearchResult(result: PDFSearchResult) {
        rootViewController.dismiss(animated: true) {
            if let viewer = self.rootViewController.topViewController as? PDFViewerViewController {
                viewer.showSearchResult(result: result.selection)
            }
        }
    }
}
