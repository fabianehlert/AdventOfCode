import Foundation
import Utilities

let validPairs = [
    "(": ")",
    "[": "]",
    "{": "}",
    "<": ">"
]

func isOpening(_ c: String) -> Bool {
    validPairs.keys.contains(c)
}

let syntaxScores = [
    ")": 3,
    "]": 57,
    "}": 1197,
    ">": 25137
]

let autocompleteScores = [
    ")": 1,
    "]": 2,
    "}": 3,
    ">": 4
]

func closingSequence(of characters: [String]) -> String {
    var remainingCharacters = characters
    var sequence = ""
    while !remainingCharacters.isEmpty {
        let c = remainingCharacters.removeLast()
        sequence.append(validPairs[c]!)
    }
    return sequence
}

/// Returns invalid character if present
func parse(_ line: String, checkClosingSequence: Bool = false) -> String? {
    var open = [String]()
    for character in line {
        if isOpening(String(character)) {
            open.append(String(character))
        } else if let lastOpen = open.last {
            if validPairs[lastOpen] == String(character) {
                open.removeLast()
            } else {
                return String(character)
            }
        } else {
            return String(character)
        }
    }
    if checkClosingSequence {
        return closingSequence(of: open)
    } else {
        return nil
    }
}

let lines = input.components(separatedBy: .newlines)

// MARK: - Part 1

let scoreOne = lines
    .compactMap { parse($0) }
    .reduce(0, { $0 + syntaxScores[$1]! })

print("Answer 1: \(scoreOne)")

// MARK: - Part 2

let incompleteLines = lines.filter { parse($0) == nil }
let closingSequences = incompleteLines.compactMap { parse($0, checkClosingSequence: true) }
let scoresTwo = closingSequences.map { line in
    line.reduce(0) {
        ($0 * 5) + autocompleteScores[String($1)]!
    }
}.sorted()

let scoreTwo = scoresTwo[(scoresTwo.count - 1) / 2]

print("Answer 2: \(scoreTwo)")
