import UIKit
import PDFKit

final class PDFViewerView: View {
    // MARK: - Subviews

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pdfView, pdfThumbnailView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private(set) lazy var pdfView: PDFView = {
        let view = PDFView()
        view.pageBreakMargins = .zero
        view.autoScales = true
        view.displayDirection = .vertical
        view.displayMode = .singlePageContinuous
        view.maxScaleFactor = 2.0
        view.minScaleFactor = view.scaleFactorForSizeToFit
        view.usePageViewController(true)
        view.enableDataDetectors = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var pdfThumbnailView: PDFThumbnailView = {
        let view = PDFThumbnailView()
        view.layoutMode = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.thumbnailSize = CGSize(width: 60, height: 100)
        view.isHidden = true
        return view
    }()

    private(set) lazy var toolboxView: PDFToolboxView = {
        let view = PDFToolboxView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        addSubview(stackView)
        addSubview(toolboxView)
    }
    
    override func setupLayoutConstraints() {
        super.setupLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            pdfThumbnailView.heightAnchor.constraint(equalToConstant: 120),
            pdfThumbnailView.widthAnchor.constraint(equalTo: widthAnchor),
            toolboxView.centerXAnchor.constraint(equalTo: centerXAnchor),
            toolboxView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            toolboxView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
