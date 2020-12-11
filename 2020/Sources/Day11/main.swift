import Foundation
import Utilities

let empty = "L"
let floor = "."
let occupied = "#"

let seatMap = input
    .components(separatedBy: .newlines)
    .map { $0.map(String.init) }

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

    var seats = seatMap
    var hasChanges = true

    while hasChanges {
        hasChanges = false

        var tempSeats = seats

        for row in seats.indices {
            for column in seats[row].indices {

                let element = seats[row][column]

                guard element != floor else { continue }

                let adjacent = adjacentSeats(row: row, column: column, seats: seats)

                switch element {
                case empty:
                    if !adjacent.contains(occupied) {
                        tempSeats[row][column] = occupied
                        hasChanges = true
                    }
                case occupied:
                    if adjacent.filter({ $0 == occupied }).count >= 4 {
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

// MARK: - Part Two

func partTwo() -> Int {

    func adjacentSeats(row: Int, column: Int, seats: [[String]]) -> [String] {

        var candidates = [String]()

        // Top
        for i in (0..<row).reversed() {
            let element = seats[i][column]
            if element == empty || element == occupied {
                candidates.append(element)
                break
            }
        }

        // Right
        for i in (column+1)..<seats[row].count {
            let element = seats[row][i]
            if element == empty || element == occupied {
                candidates.append(element)
                break
            }
        }

        // Bottom
        for i in (row+1)..<seats.count {
            let element = seats[i][column]
            if element == empty || element == occupied {
                candidates.append(element)
                break
            }
        }

        // Left
        for i in (0..<column).reversed() {
            let element = seats[row][i]
            if element == empty || element == occupied {
                candidates.append(element)
                break
            }
        }

        // Top Left
        var aRow = row - 1
        var aColumn = column - 1
        while aRow >= 0 && aColumn >= 0 {

            let element = seats[aRow][aColumn]

            if element == empty || element == occupied {
                candidates.append(element)
                break
            }

            aRow -= 1
            aColumn -= 1
        }

        // Top Right
        var bRow = row - 1
        var bColumn = column + 1
        while bRow >= 0 && bColumn < seats[row].count {

            let element = seats[bRow][bColumn]

            if element == empty || element == occupied {
                candidates.append(element)
                break
            }

            bRow -= 1
            bColumn += 1
        }

        // Bottom Left
        var cRow = row + 1
        var cColumn = column - 1
        while cRow < seats.count && cColumn >= 0 {

            let element = seats[cRow][cColumn]

            if element == empty || element == occupied {
                candidates.append(element)
                break
            }

            cRow += 1
            cColumn -= 1
        }

        // Bottom Right
        var dRow = row + 1
        var dColumn = column + 1
        while dRow < seats.count && dColumn < seats[row].count {

            let element = seats[dRow][dColumn]

            if element == empty || element == occupied {
                candidates.append(element)
                break
            }

            dRow += 1
            dColumn += 1
        }

        return candidates
    }

    var seats = seatMap
    var hasChanges = true

    while hasChanges {
        hasChanges = false

        var tempSeats = seats

        for row in seats.indices {
            for column in seats[row].indices {

                let element = seats[row][column]

                guard element != floor else { continue }

                let adjacent = adjacentSeats(row: row, column: column, seats: seats)

                switch element {
                case empty:
                    if !adjacent.contains(occupied) {
                        tempSeats[row][column] = occupied
                        hasChanges = true
                    }
                case occupied:
                    if adjacent.filter({ $0 == occupied }).count >= 5 {
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

measure {
    print("Answer Part One: \(partOne())")
    print("Answer Part Two: \(partTwo())")
}
