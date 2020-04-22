import UIKit
import PDFKit

protocol PDFViewerViewControllerDelegate: AnyObject {
    func didTapSearch(document: PDFDocument)
    func didTapTableOfContents(document: PDFDocument)
    func didTapBookmarks(document: PDFDocument)
}

final class PDFViewerViewController: ViewController {
    private lazy var customView = PDFViewerView()
    private var disposal = Disposal()
    private let viewModel: PDFViewerViewModelProtocol

    weak var delegate: PDFViewerViewControllerDelegate?

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getDocument()
    }
    
    override func setupBindings() {
        super.setupBindings()
        viewModel.document
            .observe { [weak self] (document, _) in
                self?.customView.pdfView.document = document
                self?.customView.toolboxView.tableOfContentsButton.isHidden = document?.outlineRoot == nil
            }
            .add(to: &disposal)
    }

    override func setupProperties() {
        super.setupProperties()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureRecognizer:)))

        gestureRecognizer.delegate = self
        customView.pdfView.addGestureRecognizer(gestureRecognizer)
        customView.pdfView.delegate = self
        
        customView.toolboxView.directionButton.addTarget(self, action: #selector(changeDisplayDirection), for: .touchUpInside)
        customView.toolboxView.thumbnailButton.addTarget(self, action: #selector(showThumbnail), for: .touchUpInside)
        customView.toolboxView.bookmarksButton.addTarget(self, action: #selector(bookMarksButtonTapped), for: .touchUpInside)
        customView.toolboxView.searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        customView.toolboxView.tableOfContentsButton.addTarget(self, action: #selector(tableOfContentsTapped), for: .touchUpInside)
        customView.toolboxView.showBookmarksButton.addTarget(self, action: #selector(showbookMarksButtonTapped), for: .touchUpInside)
    }

    @objc private func changeDisplayDirection() {
        customView.pdfView.displayDirection = customView.pdfView.displayDirection.next
        scalePDFViewToFit()
    }

    @objc private func showbookMarksButtonTapped() {
        delegate?.didTapBookmarks(document: viewModel.document.value!)
    }

    @objc private func bookMarksButtonTapped() {
        guard let document = viewModel.document.value else { return }
        if let documentURL = document.documentURL?.absoluteString {
            var bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int] ?? [Int]()
            if let currentPage = customView.pdfView.currentPage {
                let pageIndex = document.index(for: currentPage)
                if let index = bookmarks.firstIndex(of: pageIndex) {
                    bookmarks.remove(at: index)
                    UserDefaults.standard.set(bookmarks, forKey: documentURL)
                } else {
                    UserDefaults.standard.set((bookmarks + [pageIndex]).sorted(), forKey: documentURL)
                }
            }
        }
    }

    @objc private func searchTapped() {
        delegate?.didTapSearch(document: viewModel.document.value!)
    }

    @objc private func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        let offset: CGFloat = 64
        let location = gestureRecognizer.location(in: customView.pdfView)
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

    @objc private func showThumbnail() {
        customView.pdfThumbnailView.pdfView = customView.pdfView
        customView.pdfThumbnailView.isHidden.toggle()
    }

    @objc private func tableOfContentsTapped() {
        delegate?.didTapTableOfContents(document: viewModel.document.value!)
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

    func show(destination: PDFDestination) {
        customView.pdfView.go(to: destination)
    }

    func show(page: PDFPage) {
        customView.pdfView.go(to: page)
    }
}

extension PDFViewerViewController: PDFViewDelegate {
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        print(url)
    }
}

extension PDFViewerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
