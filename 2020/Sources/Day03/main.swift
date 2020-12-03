import Foundation

struct Slope {
    let right: Int
    let down: Int
}

typealias TreeCount = Int

let grid = input.split(whereSeparator: \.isNewline)
let width = grid[0].count

func traverse(slope: Slope) -> TreeCount {

    var xOffset = 0
    var treeCount: TreeCount = 0

    for lineOffset in stride(from: 0, to: grid.count, by: slope.down) {
        let line = grid[lineOffset]
        let index = line.index(line.startIndex, offsetBy: xOffset)

        if line[index] == Character("#") {
            treeCount += 1
        }

        xOffset = (xOffset + slope.right) % width
    }

    return treeCount
}

// MARK: - Part 1

let treeCountPartOne = traverse(slope: Slope(right: 3, down: 1))
print("Answer Part 1: \(treeCountPartOne)")

// MARK: - Part 2

let treeCountPartTwo =
    traverse(slope: Slope(right: 1, down: 1)) *
    traverse(slope: Slope(right: 3, down: 1)) *
    traverse(slope: Slope(right: 5, down: 1)) *
    traverse(slope: Slope(right: 7, down: 1)) *
    traverse(slope: Slope(right: 1, down: 2))

print("Answer Part 2: \(treeCountPartTwo)")
