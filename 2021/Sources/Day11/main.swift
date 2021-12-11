import Foundation
import Utilities

struct Index: Hashable {
    let i: Int
    let j: Int
}

func adjacentIndices(to index: Index) -> [Index] {
    let indices = [
        // Top
        Index(i: index.i-1, j: index.j-1),
        Index(i: index.i-1, j: index.j),
        Index(i: index.i-1, j: index.j+1),

        // Side
        Index(i: index.i, j: index.j-1),
        Index(i: index.i, j: index.j+1),

        // Bottom
        Index(i: index.i+1, j: index.j-1),
        Index(i: index.i+1, j: index.j),
        Index(i: index.i+1, j: index.j+1)
    ]
    return indices.filter { index in
        grid.indices.contains(index.i) &&
        grid[index.i].indices.contains(index.j)
    }
}

let formattedInput = input
    .components(separatedBy: .newlines)
    .map { $0.map { Int(String($0))! } }

var grid = formattedInput

func execute(steps: Int) -> (flashes: Int, isSyncStep: Bool) {
    var flashes = 0

    func step() -> Bool {

        var flashedIndices = Set<Index>()

        func flashAndIncreaseAdjacent(to index: Index) {
            flashedIndices.insert(index)
            for adjacentIndex in adjacentIndices(to: index) {
                grid[adjacentIndex.i][adjacentIndex.j] += 1
                if !flashedIndices.contains(adjacentIndex) && grid[adjacentIndex.i][adjacentIndex.j] > 9 {
                    flashAndIncreaseAdjacent(to: adjacentIndex)
                }
            }
        }

        // 1. Increase by 1
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                grid[i][j] += 1
            }
        }

        // 2. Flash if required
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if !flashedIndices.contains(Index(i: i, j: j)) && grid[i][j] > 9 {
                    flashAndIncreaseAdjacent(to: Index(i: i, j: j))
                }
            }
        }

        // 3. Count and reset flashed octopi
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                if grid[i][j] > 9 {
                    grid[i][j] = 0
                }
            }
        }

        flashes += flashedIndices.count

        // 4. Check Sync
        return grid.flatMap { $0 }.allSatisfy { $0 == 0 }
    }

    for _ in 0..<steps {
        let isSync = step()
        if isSync {
            return (flashes, true)
        }
    }

    return (flashes, false)
}

// MARK: - Part 1

print("Answer 1: \(execute(steps: 100).flashes)")

// MARK: - Part 2

// Reset grid for second task
grid = formattedInput

var found = false
var syncStep = 1

while !found {
    if execute(steps: 1).isSyncStep {
        found = true
    } else {
        syncStep += 1
    }
}

print("Answer 2: \(syncStep)")
