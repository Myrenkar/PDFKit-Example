import UIKit
import PDFKit

protocol PDFViewerViewControllerDelegate: AnyObject {
    func didTapSearch(document: PDFDocument)
}

final class PDFViewerViewController: ViewController {

    private lazy var customView = PDFViewerView()
    private let viewModel: PDFViewerViewModelProtocol
    private var disposal = Disposal()
    private lazy var pageObservable = Observable<PDFPage?>(customView.pdfView.currentPage)

    weak var delegate: PDFViewerViewControllerDelegate?

    private lazy var gesureRecognizer: UITapGestureRecognizer = {
        let gesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))
        gesureRecognizer.numberOfTapsRequired = 1
        gesureRecognizer.delegate = self
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
    }

    override func loadView() {
        view = customView
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.customView.pdfView.displayMode = .twoUpContinuous
            } else {
                self.customView.pdfView.displayMode = .singlePageContinuous
            }
        })
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
        
        customView.toolboxView.directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        customView.toolboxView.thumbnailButton.addTarget(self, action: #selector(showThumbnail), for: .touchUpInside)
        customView.toolboxView.resetButton.addTarget(self, action: #selector(displayModeButtonTapped), for: .touchUpInside)
        customView.toolboxView.searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }

    @objc private func directionButtonTapped() {
        customView.pdfView.displayDirection = customView.pdfView.displayDirection.next
        scalePDFViewToFit()
    }

    @objc private func displayModeButtonTapped() {
        scalePDFViewToFit()
    }

    func showSearchResult(result: PDFSelection) {
        result.color = .red
        customView.pdfView.highlightedSelections = [result]
        customView.pdfView.setCurrentSelection(result, animate: true)

        customView.pdfView.go(to: result)
    }

    @objc private func searchTapped() {
        delegate?.didTapSearch(document: viewModel.document.value!)
    }

    func scalePDFViewToFit() {
        UIView.animate(withDuration: 0.2) {
            self.customView.pdfView.scaleFactor = self.customView.pdfView.scaleFactorForSizeToFit
            self.view.layoutIfNeeded()
        }
    }

    @objc private func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        let location = gesureRecognizer.location(in: customView.pdfView)
        if location.x > 0 && location.x < 50 {
            if customView.pdfView.canGoToPreviousPage {
                customView.pdfView.goToPreviousPage(nil)
            }
        } else if location.x < customView.pdfView.frame.width && location.x > customView.pdfView.frame.width - 50 {
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

    @objc private func showThumbnail() {
        customView.pdfThumbnailView.pdfView = customView.pdfView
        customView.pdfThumbnailView.isHidden.toggle()
//        scalePDFViewToFit()
    }
}

extension PDFDisplayDirection  {
    var next:  PDFDisplayDirection {
        switch self {
            case .horizontal: return .vertical
            case .vertical: return .horizontal
            @unknown default: return .vertical
        }
    }
}

extension PDFViewerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gesureRecognizer == self.gesureRecognizer {
            return false
        }
        return true
    }
}
