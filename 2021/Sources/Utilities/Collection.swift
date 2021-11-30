import Foundation

public extension Collection {

    subscript(safe index: Index) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
