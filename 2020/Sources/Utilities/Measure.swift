import Foundation

public func measure(_ block: () -> Void) {
    let start = Date()
    block()
    print("Time: \(Date().timeIntervalSince(start) * 1000)ms")
}
