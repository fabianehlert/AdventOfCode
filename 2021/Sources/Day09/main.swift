import Foundation
import Utilities

struct Index: Hashable {
    let i: Int
    let j: Int
}

let heightMap = input
    .components(separatedBy: .newlines)
    .map { $0.map { Int(String($0))! } }

func value(of index: Index) -> Int? {
    heightMap[safe: index.i]?[safe: index.j]
}

func adjacentIndices(of index: Index) -> Set<Index> {
    [Index(i: index.i-1, j: index.j),
     Index(i: index.i+1, j: index.j),
     Index(i: index.i, j: index.j-1),
     Index(i: index.i, j: index.j+1)]
}

func adjacentValues(of index: Index) -> [Int] {
    [heightMap[safe: index.i-1]?[safe: index.j],
     heightMap[safe: index.i+1]?[safe: index.j],
     heightMap[safe: index.i]?[safe: index.j-1],
     heightMap[safe: index.i]?[safe: index.j+1]
    ].compactMap { $0 }
}

func indicesOfLowValues() -> [Index] {
    var heights = [Index]()
    for i in 0..<heightMap.count {
        for j in 0..<heightMap[i].count {
            let isLow = adjacentValues(of: Index(i: i, j: j))
                .allSatisfy({ heightMap[i][j] < $0 })

            if isLow {
                heights.append(Index(i: i, j: j))
            }
        }
    }
    return heights
}

func traverseBasin(from index: Index, previous: Set<Index>) -> Set<Index> {
    var updatedSet = previous
    updatedSet.insert(index)

    let adjacentIndices = adjacentIndices(of: index).filter {
        guard let value = value(of: $0) else {
            return false
        }
        return value != 9
    }.subtracting(previous)

    if adjacentIndices.isEmpty {
        return updatedSet
    } else {
        for adjacentIndex in adjacentIndices {
            let adjacentSet = traverseBasin(from: adjacentIndex, previous: updatedSet)
            updatedSet.formUnion(adjacentSet)
        }
        return updatedSet
    }
}

func sizesOfThreeLargestBasins() -> [Int] {
    var basinSizes = [Int]()
    let lows = indicesOfLowValues()

    for low in lows {
        var basinIndices = Set([low])
        basinIndices.formUnion(traverseBasin(from: low, previous: []))
        basinSizes.append(basinIndices.count)
    }

    return Array(basinSizes.sorted(by: >)[0..<3])
}

// MARK: - Part 1

let riskLevelSum = indicesOfLowValues()
    .map { heightMap[$0.i][$0.j] }
    .map { $0 + 1 }
    .reduce(0, +)

print("Answer 1: \(riskLevelSum)")

// MARK: - Part 2

let largesBasinsSum = sizesOfThreeLargestBasins()
    .reduce(1, *)

print("Answer 2: \(largesBasinsSum)")
