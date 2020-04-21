import PDFKit

protocol PDFViewerFactoryProtocol {
    func buildPDFViewerViewController(document: PDFDocument, delegate: PDFViewerViewControllerDelegate) -> PDFViewerViewController
    func buildDocumentListViewModeController(delegate: DocumentListViewModeControllerDelegate) -> DocumentListViewModeController
    func buildSearchViewController(document: PDFDocument, delegate: SearchViewControllerDelegate) -> SearchViewController
}

final class PDFViewerFactory: PDFViewerFactoryProtocol {
    func buildPDFViewerViewController(document: PDFDocument, delegate: PDFViewerViewControllerDelegate) -> PDFViewerViewController {
        let viewModel = PDFViewerViewModel(pdfDocument: document)
        let viewController = PDFViewerViewController(viewModel: viewModel)
        viewController.delegate = delegate
        return viewController
    }

    func buildDocumentListViewModeController(delegate: DocumentListViewModeControllerDelegate) -> DocumentListViewModeController {
        let viewModel = DocumentListViewModel(names: ["comic", "text", "the_little_prince", "buying", "CarPlay"])
        let viewController = DocumentListViewModeController(viewModel: viewModel)
        viewController.delegate = delegate
        return viewController
    }

    func buildSearchViewController(document: PDFDocument, delegate: SearchViewControllerDelegate) -> SearchViewController {
        let viewModel = SearchViewModel(document: document)
        let viewController = SearchViewController(viewModel: viewModel)
        viewController.delegate = delegate
        return viewController
    }
}
