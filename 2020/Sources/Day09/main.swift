import Foundation
import Utilities

let preamble = 25

let numbers = input
    .components(separatedBy: .newlines)
    .map(Int.init)
    .compactMap { $0 }

// MARK: - Part One

func checkSum(candidate: Int, preamble: [Int]) -> Bool {
    for a in preamble {
        for b in preamble {
            if (a != b) && (a + b == candidate) {
                return true
            }
        }
    }
    return false
}

func partOne() -> Int? {

    var index = preamble

    while index < numbers.count {
        let slice = numbers[(index-preamble)..<index]
        let candidate = numbers[index]

        guard checkSum(candidate: candidate, preamble: Array(slice)) else {
            return candidate
        }

        index += 1
    }
    return nil
}

// MARK: - Part Two

func partTwo(goal: Int) -> Int? {
    for i in numbers.indices {
        var j = i
        var sum = 0

        while j < numbers.count, sum <= goal {
            sum += numbers[j]

            if sum == goal {
                let slice = numbers[i...j]
                return slice.max()! + slice.min()!
            }

            j += 1
        }
    }
    return nil
}

measure {
    let answerPartOne = partOne()!
    print("Answer Part One: \(answerPartOne)")

    let answerPartTwo = partTwo(goal: answerPartOne)!
    print("Answer Part Two: \(answerPartTwo)")
}
