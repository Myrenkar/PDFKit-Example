import PDFKit

protocol PDFViewerViewModelProtocol {
    var document: ImmutableObservable<PDFDocument?> { get }
    func getDocument()
    var numberOfPages: Int { get }
}

final class PDFViewerViewModel: PDFViewerViewModelProtocol {

    func getDocument() {
        documentSubject.value = pdfDocument
    }

    private let documentSubject = Observable<PDFDocument?>(nil)

    private let pdfDocument: PDFDocument

    init(pdfDocument: PDFDocument) {
        self.pdfDocument = pdfDocument
    }

    private(set) lazy var document: ImmutableObservable<PDFDocument?> = {
        return documentSubject
    }()

    lazy var numberOfPages: Int = {
        return document.value?.pageCount ?? 0
    }()
}
