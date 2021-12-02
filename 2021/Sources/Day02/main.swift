import Foundation
import Utilities

enum Direction {
    case forward(Int)
    case down(Int)
    case up(Int)

    init(direction: String, value: Int) {
        switch direction {
        case "forward":
            self = .forward(value)
        case "down":
            self = .down(value)
        case "up":
            self = .up(value)
        default:
            fatalError("Unsupported direction: \(direction)")
        }
    }
}

struct Position {
    var horizontal = 0
    var depth = 0
    var aim = 0

    func multipliedPositionComponents() -> Int {
        horizontal * depth
    }

    mutating func applyPart1(_ direction: Direction) {
        switch direction {
        case .forward(let amount):
            self.horizontal += amount
        case .down(let amount):
            self.depth += amount
        case .up(let amount):
            self.depth -= amount
        }
    }

    mutating func applyPart2(_ direction: Direction) {
        switch direction {
        case .forward(let amount):
            self.horizontal += amount
            self.depth += (self.aim * amount)
        case .down(let amount):
            self.aim += amount
        case .up(let amount):
            self.aim -= amount
        }
    }
}

let directionInputs = input
    .components(separatedBy: .newlines)
    .map { instruction -> Direction in
        let components = instruction.components(separatedBy: .whitespaces)
        return Direction(direction: components[0], value: Int(components[1])!)
}

// MARK: - Part 1 + 2

var positionPart1 = Position()
var positionPart2 = Position()

for directionInput in directionInputs {
    positionPart1.applyPart1(directionInput)
    positionPart2.applyPart2(directionInput)
}

print("Answer 1: \(positionPart1.multipliedPositionComponents())")
print("Answer 2: \(positionPart2.multipliedPositionComponents())")
