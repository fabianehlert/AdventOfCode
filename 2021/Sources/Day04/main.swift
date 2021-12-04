import Foundation
import Utilities

struct Board {

    struct Value {
        let number: Int
        var isChecked: Bool = false

        init(numberString: String) {
            self.number = Int(numberString)!
        }
    }

    let id: Int
    var values: [[Value]]
    var hasWon = false

    init(boardInput: String, id: Int) {
        let rows = boardInput.components(separatedBy: .newlines)
        self.values = rows.map { row in
            row.components(separatedBy: .whitespaces)
                .filter { !$0.isEmpty }
                .map(Value.init)
        }
        self.id = id
    }

    mutating func apply(draw: Int) {
        guard !self.hasWon else { return }
        for row in 0..<self.values.count {
            for column in 0..<self.values[row].count where self.values[row][column].number == draw {
                self.values[row][column].isChecked = true
            }
        }
    }

    mutating func unmarkedSumIfWinning() -> Int? {
        guard !self.hasWon else { return nil }
        for row in 0..<self.values.count {
            // Check Horizontal Win
            if self.values[row].allSatisfy({ $0.isChecked }) {
                self.hasWon = true
                return self.sumOfUnmarkedValues()
            }
            // Check Vertical Win
            if self.values.allSatisfy({ $0[row].isChecked }) {
                self.hasWon = true
                return self.sumOfUnmarkedValues()
            }
        }
        return nil
    }

    private func sumOfUnmarkedValues() -> Int {
        self.values.flatMap { $0 }
            .filter { !$0.isChecked }
            .reduce(0, { $0 + $1.number })
    }
}

let draws = inputDraws
    .components(separatedBy: ",")
    .compactMap(Int.init)
let boards = input
    .components(separatedBy: "\n\n")
    .enumerated()
    .map { Board(boardInput: $1, id: $0) }

func playBingo() -> (answer1: Int, answer2: Int) {
    var boards = boards
    var remainingBoards = boards

    var firstWin = 0
    var lastWin = 0

    drawLoop: for (drawIndex, draw) in draws.enumerated() {
        for boardIndex in 0..<boards.count {

            boards[boardIndex].apply(draw: draw)

            guard drawIndex >= 4, let sum = boards[boardIndex].unmarkedSumIfWinning() else {
                continue
            }
            remainingBoards.removeAll { $0.id == boards[boardIndex].id }
            if firstWin == 0 {
                firstWin = draw * sum
            } else {
                lastWin = draw * sum
                if remainingBoards.isEmpty {
                    break drawLoop
                }
            }
        }
    }
    return (firstWin, lastWin)
}

let playResult = playBingo()

// MARK: - Part 1
print("Answer 1: \(playResult.answer1)")

// MARK: - Part 2
print("Answer 2: \(playResult.answer2)")
