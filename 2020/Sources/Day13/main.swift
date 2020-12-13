import Foundation
import Utilities

let puzzle = input.components(separatedBy: .newlines)

let time = Int(puzzle[0])!

let lines = puzzle[1]
    .components(separatedBy: ",")
    .compactMap(Int.init)

let lineOffsets = puzzle[1]
    .components(separatedBy: ",")
    .enumerated()
    .compactMap { line -> (line: Int, offset: Int)? in
        guard line.element != "x" else { return nil }
        return (Int(line.element)!, line.offset)
    }

// MARK: - Part One

func partOne() -> Int {

    var departureTimes = [Int: Int]()

    for line in lines {
        let diff = time % line
        departureTimes[line] = line - diff
    }

    let nearestDeparture = departureTimes.min { $0.value < $1.value }!

    return nearestDeparture.key * nearestDeparture.value
}

// MARK: - Part Two

func partTwo() -> Int {

    var time = 0
    var stamp = 1

    for line in lineOffsets {
        while ((time + line.offset) % line.line) != 0 {
            time += stamp
        }
        stamp *= line.line
    }

    return time
}

measure {
    print("Answer Part One: \(partOne())")
    print("Answer Part Two: \(partTwo())")
}
