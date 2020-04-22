import UIKit
import PDFKit

protocol SearchViewControllerDelegate: AnyObject {
    func didTapSearchResult(result: PDFSearchResult)
}

final class SearchViewController: ViewController {
    private let viewModel: SearchViewModelProtocol

    private var disposal = Disposal()
    private lazy var customView = SearchView()

    weak var delegate: SearchViewControllerDelegate?

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func setupBindings() {
        super.setupBindings()

        viewModel.searchResults.observe(.main) { [weak self] results, _ in
            self?.customView.tableView.reloadData()
        }
        .add(to: &disposal)
    }

    override func loadView() {
        view = customView
    }

    override func setupProperties() {
        super.setupProperties()

        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.searchBar.delegate = self
        customView.tableView.registerClass(SearchCell.self)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.searchResults.value.count > 0 else { return UITableViewCell() }
        let item = viewModel.searchResults.value[indexPath.row]
        let cell: SearchCell = tableView.dequeue()
        let cellViewModel = SearchCellViewModel(selection: item.selection, outline: item.outline)
        cell.pageNumberLabel.text = cellViewModel.page
        cell.resultLabel.attributedText = cellViewModel.title
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.searchResults.value[indexPath.row]
        delegate?.didTapSearchResult(result: item)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(phrase: searchText)
    }
}
