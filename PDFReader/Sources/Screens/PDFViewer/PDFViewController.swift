import UIKit
import PDFKit

protocol PDFViewerViewControllerDelegate: AnyObject {
    func didTapSearch(document: PDFDocument)
}

final class PDFViewerViewController: ViewController {
    private lazy var customView = PDFViewerView()
    private var disposal = Disposal()
    private let viewModel: PDFViewerViewModelProtocol

    weak var delegate: PDFViewerViewControllerDelegate?

    private lazy var gesureRecognizer: UITapGestureRecognizer = {
        let gesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        return gesureRecognizer
    }()

    init(viewModel: PDFViewerViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
        setupObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(pageChanged), name: .PDFViewPageChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(annotationTapped(notification:)), name: .PDFViewAnnotationHit, object: nil)
    }

    override func loadView() {
        view = customView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getDocument()
    }
    
    override func setupBindings() {
        super.setupBindings()
        viewModel.document
            .observe { [weak self] (document, _) in
                self?.customView.pdfView.document = document
        }
        .add(to: &disposal)
    }

    override func setupProperties() {
        super.setupProperties()
        customView.pdfView.addGestureRecognizer(gesureRecognizer)
        
        customView.toolboxView.directionButton.addTarget(self, action: #selector(changeDisplayDirection), for: .touchUpInside)
        customView.toolboxView.thumbnailButton.addTarget(self, action: #selector(showThumbnail), for: .touchUpInside)
        customView.toolboxView.bookmarksButton.addTarget(self, action: #selector(bookMarksButtonTapped), for: .touchUpInside)
        customView.toolboxView.searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }

    @objc private func changeDisplayDirection() {
        customView.pdfView.displayDirection = customView.pdfView.displayDirection.next
        scalePDFViewToFit()
    }

    @objc private func bookMarksButtonTapped() {
        
    }


    @objc private func searchTapped() {
        delegate?.didTapSearch(document: viewModel.document.value!)
    }

    @objc private func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        let offset: CGFloat = 50
        let location = gesureRecognizer.location(in: customView.pdfView)
        if location.x > 0 && location.x < offset {
            if customView.pdfView.canGoToPreviousPage {
                customView.pdfView.goToPreviousPage(nil)
            }
        } else if location.x < customView.pdfView.frame.width && location.x > customView.pdfView.frame.width - offset {
            if customView.pdfView.canGoToNextPage {
                customView.pdfView.goToNextPage(nil)
            }
        }
    }

    @objc func pageChanged() {
        if let pageCount = viewModel.document.value?.pageCount,
            let currentPage = customView.pdfView.currentPage,
            let pageIndex = viewModel.document.value?.index(for: currentPage) {
            customView.toolboxView.pageCounter.text = "\(pageIndex + 1)/\(pageCount)"
        }
    }

    @objc func annotationTapped(notification: NSNotification) {
        print("aalkdsad")
    }


    @objc private func showThumbnail() {
        customView.pdfThumbnailView.pdfView = customView.pdfView
        customView.pdfThumbnailView.isHidden.toggle()
    }


    private func scalePDFViewToFit() {
        UIView.animate(withDuration: 0.2) {
            self.customView.pdfView.scaleFactor = self.customView.pdfView.scaleFactorForSizeToFit
            self.view.layoutIfNeeded()
        }
    }

    func showSearchResult(result: PDFSelection) {
        result.color = .red
        customView.pdfView.highlightedSelections = [result]
        customView.pdfView.setCurrentSelection(result, animate: true)
        customView.pdfView.go(to: result)
    }
}
