import PDFKit

protocol TableOfContentViewModelProtocol {
    var outline: ImmutableObservable<[PDFOutline]> { get}
}

final class TableOfContentViewModel: TableOfContentViewModelProtocol {

    private let document: PDFDocument

    init(document: PDFDocument) {
        self.document = document
    }

    lazy var outline: ImmutableObservable<[PDFOutline]> = {
        var result: [PDFOutline] = []
        if let pdfOutline = document.outlineRoot {
            var stack = [pdfOutline]
            while !stack.isEmpty {
                let current = stack.removeLast()
                if let label = current.label, !label.isEmpty {
                    result.append(current)
                }
                for i in (0..<current.numberOfChildren).reversed() {
                    stack.append(current.child(at: i)!)
                }
            }
            return ImmutableObservable(result)
        } else {
            return ImmutableObservable([])
        }
    }()
}
