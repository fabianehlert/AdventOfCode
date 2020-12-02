import Foundation

// MARK: - Extensions

extension Collection {

    subscript(safe index: Index) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        }
        return nil
    }
}

// MARK: - Password

struct Password {
    let policy: (min: Int, max: Int, character: Character)
    let phrase: String
}

extension Password {

    var isValidOne: Bool {
        let occurrences = self.phrase.filter { $0 == self.policy.character }.count
        return (self.policy.min...self.policy.max).contains(occurrences)
    }

    var isValidTwo: Bool {
        let first = self.phrase[safe: self.phrase.index(self.phrase.startIndex, offsetBy: self.policy.min - 1)]
        let second = self.phrase[safe: self.phrase.index(self.phrase.startIndex, offsetBy: self.policy.max - 1)]

        var firstMatches = false
        if let first = first {
            firstMatches = first == self.policy.character
        }

        var secondMatches = false
        if let second = second {
            secondMatches = second == self.policy.character
        }

        return (firstMatches && !secondMatches) || (!firstMatches && secondMatches)
    }
}

let passwords = input.split(whereSeparator: \.isNewline).map { line -> Password in
    let parts = line.split(separator: " ")

    let amount = String(parts[0]).split(separator: "-")
    let min = Int(amount[0])!
    let max = Int(amount[1])!

    let char = parts[1][parts[1].startIndex]

    let phrase = String(parts[2])

    return Password(policy: (min, max, char),
                    phrase: phrase)
}

// MARK: - Part 1

let validPasswordsCountPartOne = passwords.filter(\.isValidOne).count
print("Answer 1: \(validPasswordsCountPartOne)")

// MARK: - Part 2

let validPasswordsCountPartTwo = passwords.filter(\.isValidTwo).count
print("Answer 2: \(validPasswordsCountPartTwo)")
