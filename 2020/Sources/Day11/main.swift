import Foundation
import Utilities

let empty = "L"
let floor = "."
let occupied = "#"

let seatMap = input
    .components(separatedBy: .newlines)
    .map { $0.map(String.init) }

func fillSeats(_ seats: [[String]],
               limit: Int,
               adjacentSeats: (_ row: Int, _ column: Int, _ seats: [[String]]) -> [String]) -> Int {

    var seats = seats
    var hasChanges = true

    while hasChanges {
        hasChanges = false

        var tempSeats = seats

        for row in seats.indices {
            for column in seats[row].indices {

                let element = seats[row][column]

                guard element != floor else { continue }

                let adjacent = adjacentSeats(row, column, seats)

                switch element {
                case empty:
                    if !adjacent.contains(occupied) {
                        tempSeats[row][column] = occupied
                        hasChanges = true
                    }
                case occupied:
                    if adjacent.filter({ $0 == occupied }).count >= limit {
                        tempSeats[row][column] = empty
                        hasChanges = true
                    }
                default:
                    break
                }
            }
        }

        seats = tempSeats
    }

    return seats
        .flatMap { $0 }
        .filter { $0 == occupied }
        .count
}

// MARK: - Part One

func partOne() -> Int {

    func adjacentSeats(row: Int, column: Int, seats: [[String]]) -> [String] {
        return [
            seats[safe: row]?[safe: column-1],
            seats[safe: row]?[safe: column+1],
            seats[safe: row-1]?[safe: column],
            seats[safe: row+1]?[safe: column],
            seats[safe: row-1]?[safe: column-1],
            seats[safe: row-1]?[safe: column+1],
            seats[safe: row+1]?[safe: column-1],
            seats[safe: row+1]?[safe: column+1]
        ].compactMap { $0 }
    }

    return fillSeats(seatMap, limit: 4, adjacentSeats: adjacentSeats(row:column:seats:))
}

// MARK: - Part Two

func partTwo() -> Int {

    func adjacentSeats(row: Int, column: Int, seats: [[String]]) -> [String] {

        var candidates = [String]()

        struct Direction {
            let row: Int
            let column: Int
        }

        let directions = [
            Direction(row: -1, column: 0), // Top
            Direction(row: 0, column: 1), // Right
            Direction(row: 1, column: 0), // Bottom
            Direction(row: 0, column: -1), // Left

            Direction(row: -1, column: -1), // Diag, Top Left
            Direction(row: -1, column: 1), // Diag, Top Right
            Direction(row: 1, column: -1), // Diag, Bottom Left
            Direction(row: 1, column: 1) // Diag, Bottom Right
        ]

        for direction in directions {
            var r = row + direction.row
            var c = column + direction.column

            while seats.indices.contains(r) && seats[r].indices.contains(c) {
                let element = seats[r][c]
                if element == empty || element == occupied {
                    candidates.append(element)
                    break
                }

                r += direction.row
                c += direction.column
            }
        }
        return candidates
    }

    return fillSeats(seatMap, limit: 5, adjacentSeats: adjacentSeats(row:column:seats:))
}

measure {
    print("Answer Part One: \(partOne())")
    print("Answer Part Two: \(partTwo())")
}
