import PDFKit
import UIKit

protocol BookmarksViewControllerDelegate: AnyObject {
    func didSelect(page: PDFPage)
}

final class BookmarksViewController: ViewController {
    private let viewModel: BookmarksViewModelProtocol
    private lazy var customView = BookmarksView()
    private var disposal = Disposal()

    weak var delegate: BookmarksViewControllerDelegate?

    init(viewModel: BookmarksViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func setupProperties() {
        super.setupProperties()
        customView.collectionView.registerClass(BookmarksCell.self)
        customView.collectionView.dataSource = self
        customView.collectionView.delegate = self
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.bookmarks.observe(.main) { [weak self] (value, _) in
            self?.customView.collectionView.reloadData()
        }
        .add(to: &disposal)
    }

    override func loadView() {
        view = customView
    }
}

extension BookmarksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bookmarks.value.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarksCell = collectionView.dequeue(forIndexPath: indexPath)
        let element = viewModel.bookmarks.value[indexPath.row]
        let cellViewModel = BookmarksCellViewModel(document: viewModel.document, size: cell.frame.size, pageNumber: element)
        cell.imageView.image = cellViewModel.coverImage
        cell.nameLabel.text = cellViewModel.tilte
        return cell
    }
}

extension BookmarksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = viewModel.document.page(at: viewModel.bookmarks.value[indexPath.row]) {
            delegate?.didSelect(page: page)
        }
    }
}
