
/// Describes a type that is providing application dependencies.
protocol ApplicationDependenciesProvider {
    var pdfViewerFactory: PDFViewerFactoryProtocol { get }
}

final class DefaultApplicationDependenciesProvider: ApplicationDependenciesProvider {

    lazy var pdfViewerFactory: PDFViewerFactoryProtocol = {
        PDFViewerFactory()
    }()

}
