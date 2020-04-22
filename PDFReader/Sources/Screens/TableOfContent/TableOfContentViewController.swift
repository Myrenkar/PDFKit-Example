import PDFKit
import UIKit

protocol TableOfContentViewControllerDelegate: AnyObject {
    func didSelect(destination: PDFDestination)
}

final class TableOfContentViewController: ViewController {
    private let viewModel: TableOfContentViewModelProtocol
    private lazy var customView = TableOfContentView()
    private var disposal = Disposal()

    weak var delegate: TableOfContentViewControllerDelegate?

    init(viewModel: TableOfContentViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func setupProperties() {
        super.setupProperties()
        customView.tableView.registerClass(TableOfContentCell.self)
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.outline.observe(.main) { [weak self] (value, _) in
            self?.customView.tableView.reloadData()
        }
        .add(to: &disposal)
    }

    override func loadView() {
        view = customView
    }
}

extension TableOfContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outline.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableOfContentCell = tableView.dequeue()
        let element = viewModel.outline.value[indexPath.row]
    
        var indentationLevel = -1
        var parent = element.parent
        while let _ = parent {
            indentationLevel += 1
            parent = parent?.parent
        }
        cell.indentationLevel = indentationLevel
        cell.textLabel?.text = element.label

        return cell
    }
}

extension TableOfContentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let destination = viewModel.outline.value[indexPath.row].destination {
            delegate?.didSelect(destination: destination)
        }
    }
}
