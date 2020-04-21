import Foundation

typealias Disposal = [Disposable]

final class Disposable {

    private let dispose: () -> ()

    init(_ dispose: @escaping () -> ()) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
