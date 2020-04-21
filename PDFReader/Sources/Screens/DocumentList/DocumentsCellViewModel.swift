import UIKit
import PDFKit

protocol DocumentsCellViewModelProtocol {
    var coverImage: UIImage? { get }
    var tilte: String? { get }
}

final class DocumentsCellViewModel: DocumentsCellViewModelProtocol {
    private let document: PDFDocument
    private let size: CGSize

    init(document: PDFDocument, size: CGSize) {
        self.document = document
        self.size = size
    }

    var coverImage: UIImage? {
        return document.page(at: 0)?.thumbnail(of: size, for: .artBox)
    }

    var tilte: String? {
        return document.outlineRoot?.child(at: 0)?.label
    }

}
