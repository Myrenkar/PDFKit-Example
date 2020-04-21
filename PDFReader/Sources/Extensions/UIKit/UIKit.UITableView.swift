import UIKit

extension UITableView {
    func registerClass<CellType: UITableViewCell>(_ type: CellType.Type) where CellType: Reusable {
        register(CellType.self, forCellReuseIdentifier: CellType.reuseIdentifier)
    }

    func dequeue<CellType: UITableViewCell>(forIndexPath indexPath: IndexPath) -> CellType where CellType: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType else {
            fatalError("Could not dequeue cell of type \(CellType.self) with reuseIdentifier \(CellType.reuseIdentifier)")
        }
        return cell
    }
}
