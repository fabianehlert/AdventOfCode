import Foundation
import Utilities

let allowedJoltageDifference = 1...3

var sortedAdapters = input
    .components(separatedBy: .newlines)
    .map(Int.init)
    .compactMap { $0 }
    .sorted()

// MARK: - Part One

func partOne() -> Int {

    var joltage = 0
    var differences = [1: 0,
                       2: 0,
                       3: 0]

    for adapter in sortedAdapters {
        let diff = adapter - joltage

        if allowedJoltageDifference.contains(diff) {
            joltage = adapter
            differences[diff]! += 1
        } else {
            break
        }
    }

    // "your device's built-in adapter is always 3 higher than the highest adapter"
    differences[3]! += 1

    return differences[1]! * differences[3]!
}

// MARK: - Part Two

func partTwo() -> Int {

    var cache = [Int: Int]()

    func traverseNextElements(node: Int, maximum: Int) -> Int {
        var counter = 0

        let nodeIndex = sortedAdapters.firstIndex(where: { $0 == node })!

        let range = min(nodeIndex+1, sortedAdapters.count-1)...min(nodeIndex+3, sortedAdapters.count-1)
        let nextCandidates = sortedAdapters[range].filter { allowedJoltageDifference.contains($0 - node) }

        if node == maximum {
            return 1
        }

        for next in nextCandidates {
            if let cached = cache[next] {
                counter += cached
            } else {
                let result = traverseNextElements(node: next, maximum: maximum)
                cache[next] = result
                counter += result
            }
        }

        return counter
    }

    // Add seat joltage rating
    sortedAdapters.insert(0, at: 0)

    return traverseNextElements(node: 0, maximum: sortedAdapters.max()!)
}

measure {
    print("Answer Part One: \(partOne())")
    print("Answer Part Two: \(partTwo())")
}
