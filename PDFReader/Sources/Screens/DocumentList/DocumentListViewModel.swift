import PDFKit

protocol DocumentListViewModelProtocol {
    var documents: ImmutableObservable<[PDFDocument]> { get }
    var title: ImmutableObservable<String> { get }
}

final class DocumentListViewModel: DocumentListViewModelProtocol {

    private let names: [String]

    init(names: [String]) {
        self.names = names
    }

    lazy var documents: ImmutableObservable<[PDFDocument]> = {
        let docs: [PDFDocument] = names.compactMap { value in
            guard let url = Bundle.main.url(forResource: value, withExtension: "pdf"),
                let pdfDocumnet = PDFDocument(url: url) else { return nil }
            return pdfDocumnet
        }
        return ImmutableObservable(docs)
    }()

    let title: ImmutableObservable<String> = ImmutableObservable("Choose file")
}   
