import Foundation
import Utilities

struct DiagnosticStore {

    let diagnostics: [[Int]]
    let rotatedDiagnostics: [[Int]]

    init(diagnoticReport: [String]) {
        self.diagnostics = diagnoticReport.map { reportLine in
            reportLine.compactMap { $0.wholeNumberValue }
        }

        let width = self.diagnostics[0].count
        let height = self.diagnostics.count
        var rotatedDiagnostics = Array(repeating: Array(repeating: -1, count: height), count: width)
        for column in 0..<width {
            for row in 0..<self.diagnostics.count {
                rotatedDiagnostics[column][row] = self.diagnostics[row][column]
            }
        }
        self.rotatedDiagnostics = rotatedDiagnostics
    }

    func mostCommonNumbers() -> [Int] {
        let count = self.diagnostics.count
        let width = self.diagnostics[0].count
        var common1Counts = Array(repeating: 0, count: width)
        for diagnostic in diagnostics {
            for (index, number) in diagnostic.enumerated() {
                if number == 1 {
                    common1Counts[index] += 1
                }
            }
        }
        var finalCounters = Array(repeating: -1, count: width)
        for (index, common1) in common1Counts.enumerated() {
            if common1 < (count / 2) {
                finalCounters[index] = 0
            } else {
                finalCounters[index] = 1
            }
        }
        return finalCounters
    }

    private func rotate(numbers: [[Int]]) -> [[Int]] {
        let width = numbers[0].count
        let height = numbers.count
        var rotated = Array(repeating: Array(repeating: -1, count: height), count: width)
        for column in 0..<width {
            for row in 0..<numbers.count {
                rotated[column][row] = numbers[row][column]
            }
        }
        return rotated
    }

    private enum Common {
        case least, most
    }

    private func lookingFor(with common: Common, in numbers: [Int]) -> Int {
        let zeros = numbers.filter { $0 == 0 }.count
        let ones = numbers.filter { $0 == 1 }.count

        switch common {
        case .least:
            return zeros <= ones ? 0 : 1
        case .most:
            return ones >= zeros ? 1 : 0
        }
    }

    func part2() -> (String, String) {
        func filter(numbers: [[Int]], by common: Common, in column: Int) -> [[Int]] {
            guard numbers[0].count > 1 else {
                return numbers
            }
            let lookingFor = self.lookingFor(with: common, in: numbers[column])
            let rowsToRemove = numbers[column].indices.filter { numbers[column][$0] != lookingFor }
            var filteredNumbers = numbers
            for column in 0..<filteredNumbers.count {
                for removeIndex in rowsToRemove.reversed() {
                    filteredNumbers[column].remove(at: removeIndex)
                }
            }
            return filter(numbers: filteredNumbers, by: common, in: column + 1)
        }

        let oxygenGenerator = filter(numbers: self.rotatedDiagnostics, by: .most, in: 0)
            .flatMap { $0.map(String.init) }
            .joined()
        let co2Scrubber = filter(numbers: self.rotatedDiagnostics, by: .least, in: 0)
            .flatMap { $0.map(String.init) }
            .joined()
        return (oxygenGenerator, co2Scrubber)
    }
}

let report = input.components(separatedBy: .newlines)
let diagnosticStore = DiagnosticStore(diagnoticReport: report)

// MARK: - Part 1

let gamma = diagnosticStore.mostCommonNumbers()
let epsilon = gamma.map { $0 == 1 ? 0 : 1 }

let stringGamma = gamma
    .map(String.init)
    .joined()
let decimalGamma = Int(stringGamma, radix: 2)!

let stringEpsilon = epsilon
    .map(String.init)
    .joined()
let decimalEpsilon = Int(stringEpsilon, radix: 2)!

let powerConsumption = decimalGamma * decimalEpsilon

print("Answer 1: \(powerConsumption)")

// MARK: - Part 2

let part2 = diagnosticStore.part2()
let answer2 = Int(part2.0, radix: 2)! * Int(part2.1, radix: 2)!
print("Answer 2: \(answer2)")
