import PDFKit

extension PDFDisplayDirection {
    var next:  PDFDisplayDirection {
        switch self {
            case .horizontal: return .vertical
            case .vertical: return .horizontal
            @unknown default: return .vertical
        }
    }
}

