import Foundation
import Utilities

struct Line: Hashable, CustomDebugStringConvertible {
    let p1: String
    let p2: String

    var debugDescription: String {
        "\(p1)-\(p2)"
    }

    init(raw: String) {
        let components = raw.components(separatedBy: "-")
        self.p1 = components[0]
        self.p2 = components[1]
    }

    static func canVisitAgain(_ pointValue: String) -> Bool {
        pointValue.allSatisfy { $0.isUppercase }
    }

    static func isStart(_ pointValue: String) -> Bool {
        pointValue == "start"
    }

    static func isEnd(_ pointValue: String) -> Bool {
        pointValue == "end"
    }
}

let paths = input
    .components(separatedBy: .newlines)
    .map(Line.init)

let destinationLookup = paths.reduce(into: [String: Set<String>]()) { partialResult, path in
    partialResult[path.p1] = Set([path.p2]).union(optional: partialResult[path.p1])
    partialResult[path.p2] = Set([path.p1]).union(optional: partialResult[path.p2])
}

func findPaths() -> Int {

    func traverse(initialNode: String,
                  previous: Int = 0,
                  previousNodes: Set<String> = []) -> Int {

        guard initialNode != "end" else {
            return previous + 1
        }

        let visitedNodes = previousNodes.union([initialNode])

        let nextNodes = destinationLookup[initialNode]!.filter { node in
            let visited = visitedNodes.contains(node)
            let canVisitAgain = Line.canVisitAgain(node)
            let isStart = Line.isStart(node)
            return !isStart && (!visited || canVisitAgain)
        }

        var pathCounter = previous

        for node in nextNodes {
            let newPaths = traverse(initialNode: node,
                                    previous: previous,
                                    previousNodes: visitedNodes)
            pathCounter += newPaths
        }

        return pathCounter
    }

    return traverse(initialNode: "start")
}

// MARK: - Part 1

print("Answer 1: \(findPaths())")
