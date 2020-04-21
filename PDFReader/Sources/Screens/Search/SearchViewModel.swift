import PDFKit

protocol SearchViewModelProtocol {
    func search(phrase: String)
    var searchResults: ImmutableObservable<[PDFSearchResult]> { get}
}

final class SearchViewModel: NSObject,  SearchViewModelProtocol {
    private let document: PDFDocument
    private let searchResultsSubject = Observable<[PDFSearchResult]>([])

    init(document: PDFDocument) {
        self.document = document
        super.init()
        document.delegate = self
    }

    func search(phrase: String) {
        document.cancelFindString()
        searchResultsSubject.value.removeAll()
        document.beginFindString(phrase, withOptions: .caseInsensitive)
    }

    lazy var searchResults: ImmutableObservable<[PDFSearchResult]> = {
        return searchResultsSubject
    }()
}

extension SearchViewModel: PDFDocumentDelegate {
    func didMatchString(_ instance: PDFSelection) {
        if let selectionPage = instance.pages.first {
            let page = document.index(for: selectionPage)
            let outline = document.outlineItem(for: instance)
            searchResultsSubject.value.append(PDFSearchResult(selection: instance, page: page, outline: outline))
        }
    }
}


struct PDFSearchResult {
    let selection: PDFSelection
    let page: Int
    let outline: PDFOutline?
}
