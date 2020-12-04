import Foundation

struct Passport {

    let raw: [String: String]

    var isValid: Bool {

        guard
            let birthYear = raw["byr"],
            let issueYear = raw["iyr"],
            let expirationYear = raw["eyr"],
            let height = raw["hgt"],
            let hairColor = raw["hcl"],
            let eyeColor = raw["ecl"],
            let passportID = raw["pid"]
        else {
            return false
        }

        guard (1920...2002).contains(Int(birthYear) ?? 0) else {
            return false
        }

        guard (2010...2020).contains(Int(issueYear) ?? 0) else {
            return false
        }

        guard (2020...2030).contains(Int(expirationYear) ?? 0) else {
            return false
        }

        if height.hasSuffix("cm") {
            guard let cm = Int(height.dropLast(2)), (150...193).contains(cm) else {
                return false
            }
        } else if height.hasSuffix("in") {
            guard let inch = Int(height.dropLast(2)), (59...76).contains(inch) else {
                return false
            }
        } else {
            return false
        }

        let range = NSRange(location: 0, length: hairColor.utf16.count)
        let regex = try! NSRegularExpression(pattern: "#([0-9a-f]{6})")
        guard regex.firstMatch(in: hairColor, options: [], range: range) != nil else {
            return false
        }

        guard ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(eyeColor) else {
            return false
        }

        guard Int(passportID) != nil, passportID.count == 9 else {
            return false
        }

        return true
    }
}

let rawPassports = input.components(separatedBy: "\n\n")

// MARK: - Part One

let mandatoryFields = ["byr:",
                       "iyr:",
                       "eyr:",
                       "hgt:",
                       "hcl:",
                       "ecl:",
                       "pid:"]

// MARK: - Part One

let answerPartOne = rawPassports.filter { mandatoryFields.allSatisfy($0.contains) }.count
print("Answer Part One: \(answerPartOne)")

// MARK: - Part Two

let passports = rawPassports
    .map { $0.replacingOccurrences(of: "\n", with: " ") }
    .map { $0.split(separator: " ") }
    .map { keyValuePairSequence -> [(String, String)] in
        return keyValuePairSequence.map { keyValuePair -> (String, String) in
            let parts = keyValuePair.split(separator: ":")
            return (String(parts[0]), String(parts[1]))
        }
    }
    .map { Dictionary($0, uniquingKeysWith: { (first, _) in first }) }
    .map(Passport.init)

let answerPartTwo = passports.filter(\.isValid).count
print("Answer Part Two: \(answerPartTwo)")
