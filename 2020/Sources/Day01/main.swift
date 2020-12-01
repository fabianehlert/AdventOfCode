import Foundation

// MARK: - Part 1

let inputSet = Set(input)

var entriesPartOne = (0, 0)

outerLoop: for a in inputSet {
    for b in inputSet where a != b {
        if a + b == 2020 {
            entriesPartOne = (a, b)
            break outerLoop
        }
    }
}

let resultPartOne = entriesPartOne.0 * entriesPartOne.1
print("Answer 1: \(resultPartOne)")

// MARK: - Part 2

var entriesPartTwo = (0, 0, 0)

outerLoop: for a in inputSet {
    for b in inputSet where a != b {
        for c in inputSet where b != c {
            if a + b + c == 2020 {
                entriesPartTwo = (a, b, c)
                break outerLoop
            }
        }
    }
}

let resultPartTwo = entriesPartTwo.0 * entriesPartTwo.1 * entriesPartTwo.2
print("Answer 2: \(resultPartTwo)")
