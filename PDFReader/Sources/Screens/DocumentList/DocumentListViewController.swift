import UIKit
import PDFKit

protocol DocumentListViewModeControllerDelegate: AnyObject {
    func didSelect(document: PDFDocument)
}

final class DocumentListViewModeController: ViewController {
    private var disposal = Disposal()
    private lazy var customView = DocumentListView()
    private let viewModel: DocumentListViewModelProtocol

    weak var delegate: DocumentListViewModeControllerDelegate?

    init(viewModel: DocumentListViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        view = customView
    }

    override func setupBindings() {
        super.setupBindings()

        viewModel.documents
            .observe(.main) { [weak self] (docs, _) in
                self?.customView.collectionView.reloadData()
            }
            .add(to: &disposal)

        viewModel.title
            .observe(.main) { [weak self] title, _ in
                self?.title = title
            }
            .add(to: &disposal)
    }

    override func setupProperties() {
        super.setupProperties()
        customView.collectionView.registerClass(DocumentCell.self)
        customView.collectionView.delegate = self
        customView.collectionView.dataSource = self
    }
}

extension DocumentListViewModeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.documents.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.documents.value[indexPath.row]
        let cell: DocumentCell = collectionView.dequeue(forIndexPath: indexPath)
        let cellViewModel = DocumentsCellViewModel(document: item, size: cell.frame.size)
        cell.imageView.image = cellViewModel.coverImage
        cell.nameLabel.text = cellViewModel.tilte

        return cell
    }
}

extension DocumentListViewModeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.documents.value[indexPath.row]
        delegate?.didSelect(document: item)
    }
}
