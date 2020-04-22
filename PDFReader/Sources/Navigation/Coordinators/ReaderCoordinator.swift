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
    func didTapBookmarks(document: PDFDocument) {
        let viewController = factory.buildBookmarksViewController(document: document, delegate: self)
        rootViewController.pushViewController(viewController, animated: true)
    }

    func didTapTableOfContents(document: PDFDocument) {
        let viewController = factory.buildTableOfContentsViewController(document: document, delegate: self)
        rootViewController.pushViewController(viewController, animated: true)
    }

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

extension ReaderCoordinator: TableOfContentViewControllerDelegate {
    func didSelect(destination: PDFDestination) {
        rootViewController.popViewController(animated: true)
        if let viewer = self.rootViewController.topViewController as? PDFViewerViewController {
            viewer.show(destination: destination)
        }
    }
}

extension ReaderCoordinator: BookmarksViewControllerDelegate {
    func didSelect(page: PDFPage) {
        rootViewController.popViewController(animated: true)
        if let viewer = self.rootViewController.topViewController as? PDFViewerViewController {
            viewer.show(page: page)
        }
    }
}
