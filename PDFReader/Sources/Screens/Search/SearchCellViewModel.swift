import PDFKit

protocol SearchCellViewModelProtocol {
    var title: NSAttributedString { get }
    var page: String { get }
}

final class SearchCellViewModel: SearchCellViewModelProtocol {

    private let selection: PDFSelection
    private let outline: PDFOutline?

    init(selection: PDFSelection, outline: PDFOutline?) {
        self.selection = selection
        self.outline = outline
    }

    // MARK: - SearchCellViewModelProtocol
    lazy var title: NSAttributedString = {
        let selectionCopy = selection.copy() as! PDFSelection
        selectionCopy.extend(atStart: 2)
        selectionCopy.extend(atEnd: 10)
        selectionCopy.extendForLineBoundaries()

        if let text = selectionCopy.string, let rangeText = selection.string {
            let range = (text as NSString).range(of: rangeText, options: .caseInsensitive)
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttributes([.backgroundColor: UIColor.yellow], range: range)
            return attributed
        } else {
            return selection.attributedString ?? NSAttributedString()
        }
    }()

    var page: String {
        if let text = outline?.label {
            return text
        } else {
            let text = selection.pages.first?.string ?? "no page"
            return "Page: \(text)"
        }
    }
}
