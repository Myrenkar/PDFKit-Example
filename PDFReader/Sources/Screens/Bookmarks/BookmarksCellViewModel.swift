import UIKit
import PDFKit

protocol BookmarksCellViewModelProtocol {
    var coverImage: UIImage? { get }
    var tilte: String? { get }
}

final class BookmarksCellViewModel: BookmarksCellViewModelProtocol {
    private let document: PDFDocument
    private let size: CGSize
    private let pageNumber: Int

    init(document: PDFDocument, size: CGSize, pageNumber: Int) {
        self.document = document
        self.size = size
        self.pageNumber = pageNumber
    }

    var coverImage: UIImage? {
        return document.page(at: pageNumber)?.thumbnail(of: size, for: .artBox)
    }

    var tilte: String? {
        return "Page: \(pageNumber)"
    }

}
