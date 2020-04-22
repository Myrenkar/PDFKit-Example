import PDFKit

protocol BookmarksViewModelProtocol {
    var bookmarks: ImmutableObservable<[Int]> { get }
    var document: PDFDocument { get }
}

final class BookmarksViewModel: BookmarksViewModelProtocol {
    
    let document: PDFDocument
    
    init(document: PDFDocument) {
        self.document = document
    }
    
    lazy var bookmarks: ImmutableObservable<[Int]> = {
        if let documentURL = document.documentURL?.absoluteString,
            let bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int] {
            return ImmutableObservable(bookmarks)
        } else {
            return ImmutableObservable([])
        }
    }()
}
