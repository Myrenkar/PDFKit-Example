import UIKit
extension UITableView {
    
    func registerClass<CellType: UITableViewCell>(_ type: CellType.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeue<CellType: UITableViewCell>() -> CellType {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.reuseIdentifier) as? CellType else {
            fatalError("Could not dequeue cell of type \(CellType.self) with reuseIdentifier \(CellType.reuseIdentifier)")
        }
        return cell
    }
    
}
