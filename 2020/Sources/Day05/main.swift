import Foundation

struct BoardingPass {

    enum BoardingPassError: Error {
        case invalidCharacter
    }

    typealias SeatID = Int

    let seatSpecification: String

    var rowSpecification: String {
        String(seatSpecification.dropLast(3))
    }

    var columnSpecification: String {
        String(seatSpecification.dropFirst(7))
    }

    func calculateSeatID() -> SeatID {
        do {
            let row = try binarySearch(by: rowSpecification,
                                       lower: Character("F"),
                                       upper: Character("B"),
                                       range: 0...127)
            let column = try binarySearch(by: columnSpecification,
                                          lower: Character("L"),
                                          upper: Character("R"),
                                          range: 0...7)
            return row * 8 + column
        } catch let error {
            print(error)
            return 0
        }
    }
}

extension BoardingPass {

    func binarySearch(by phrase: String,
                      index: Int = 0,
                      lower: Character,
                      upper: Character,
                      range: ClosedRange<Int>) throws -> Int {

        if range.lowerBound >= range.upperBound {
            return range.lowerBound
        }

        let selectedChar = phrase[phrase.index(phrase.startIndex, offsetBy: index)]
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

        if selectedChar == lower {
            return try binarySearch(by: phrase,
                                    index: index + 1,
                                    lower: lower,
                                    upper: upper,
                                    range: range.lowerBound...midIndex)
        } else if selectedChar == upper {
            return try binarySearch(by: phrase,
                                    index: index + 1,
                                    lower: lower,
                                    upper: upper,
                                    range: (midIndex+1)...range.upperBound)
        } else {
            throw BoardingPassError.invalidCharacter
        }
    }
}

extension Array where Element == BoardingPass.SeatID {

    func findMissingSeatID() -> BoardingPass.SeatID {

        var missingSeatID: BoardingPass.SeatID = 0

        for i in 0..<self.count {

            guard i+1 < self.count else {
                break
            }

            let current = self[i]
            let next = self[i+1]

            if next > (current + 1) {
                missingSeatID = current + 1
                break
            }
        }

        return missingSeatID
    }
}

let boardingPasses = input
    .components(separatedBy: .newlines)
    .map(BoardingPass.init)

let seatIDs = boardingPasses
    .map { $0.calculateSeatID() }
    .sorted()

// MARK: - Part One

let highestSeatID = seatIDs.last ?? 0
print("Answer Part One: \(highestSeatID)")

// MARK: - Part Two

let missingSeatID = seatIDs.findMissingSeatID()
print("Answer Part Two: \(missingSeatID)")
