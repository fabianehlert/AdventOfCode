import Foundation

public extension Set {
    func union<S>(optional other: S?) -> Set<Element> where Element == S.Element, S : Sequence {
        guard let other = other else {
            return self
        }
        return self.union(other)
    }
}
