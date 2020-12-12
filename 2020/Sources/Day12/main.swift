import Foundation
import Utilities

enum Heading: String {

    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"

    func converted(using action: Action) -> Heading {
        switch action {
        case .L(let rotations):
            switch self {
            case .north:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .west
                case 2:
                    return .south
                case 3:
                    return .east
                default:
                    preconditionFailure("Too many rotations")
                }
            case .south:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .east
                case 2:
                    return .north
                case 3:
                    return .west
                default:
                    preconditionFailure("Too many rotations")
                }
            case .east:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .north
                case 2:
                    return .west
                case 3:
                    return .south
                default:
                    preconditionFailure("Too many rotations")
                }
            case .west:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .south
                case 2:
                    return .east
                case 3:
                    return .north
                default:
                    preconditionFailure("Too many rotations")
                }
            }
        case .R(let rotations):
            switch self {
            case .north:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .east
                case 2:
                    return .south
                case 3:
                    return .west
                default:
                    preconditionFailure("Too many rotations")
                }
            case .south:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .west
                case 2:
                    return .north
                case 3:
                    return .east
                default:
                    preconditionFailure("Too many rotations")
                }
            case .east:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .south
                case 2:
                    return .west
                case 3:
                    return .north
                default:
                    preconditionFailure("Too many rotations")
                }
            case .west:
                switch rotations {
                case 0:
                    return self
                case 1:
                    return .north
                case 2:
                    return .east
                case 3:
                    return .south
                default:
                    preconditionFailure("Too many rotations")
                }
            }
        default:
            return self
        }
    }
}

enum Action {

    case N(Int)
    case S(Int)
    case E(Int)
    case W(Int)
    case L(Int)
    case R(Int)
    case F(Int)

    init(_ raw: String) {
        let direction = raw.first!
        let amount = Int(raw.dropFirst())!

        switch direction {
        case "N":
            self = .N(amount)
        case "S":
            self = .S(amount)
        case "E":
            self = .E(amount)
        case "W":
            self = .W(amount)
        case "L":
            self = .L(amount/90)
        case "R":
            self = .R(amount/90)
        case "F":
            self = .F(amount)
        default:
            preconditionFailure("Unexpected direction: \(direction)")
        }
    }
}

let actions = input
    .components(separatedBy: .newlines)
    .map(Action.init)

// MARK: - Part One

func partOne() -> Int {

    var loc = (row: 0, column: 0)
    var heading = Heading.east

    for action in actions {
        heading = heading.converted(using: action)

        switch action {
        case .F(let amount):
            switch heading {
            case .north:
                loc = (loc.row - amount, loc.column)
            case .south:
                loc = (loc.row + amount, loc.column)
            case .east:
                loc = (loc.row, loc.column + amount)
            case .west:
                loc = (loc.row, loc.column - amount)
            }

        case .N(let amount):
            loc = (loc.row - amount, loc.column)

        case .S(let amount):
            loc = (loc.row + amount, loc.column)

        case .E(let amount):
            loc = (loc.row, loc.column + amount)

        case .W(let amount):
            loc = (loc.row, loc.column - amount)

        default:
            break
        }
    }

    return abs(loc.row) + abs(loc.column)
}

// MARK: - Part Two

func partTwo() -> Int {

    var ship = (0, 0)
    var wayPoint = (east: 10, north: 1)

    for action in actions {
        switch action {
        case .N(let amount):
            wayPoint.north += amount

        case .S(let amount):
            wayPoint.north -= amount

        case .E(let amount):
            wayPoint.east += amount

        case .W(let amount):
            wayPoint.east -= amount

        case .R(let amount):
            for _ in 0..<amount {
                let newNorth = -wayPoint.east
                wayPoint.east = wayPoint.north
                wayPoint.north = newNorth
            }

        case .L(let amount):
            for _ in 0..<amount {
                let newNorth = wayPoint.east
                wayPoint.east = -wayPoint.north
                wayPoint.north = newNorth
            }

        case .F(let amount):
            ship = (ship.0 + amount * wayPoint.north,
                    ship.1 + amount * wayPoint.east)
        }
    }

    return abs(ship.0) + abs(ship.1)
}

measure {
    print("Answer Part One: \(partOne())")
    print("Answer Part Two: \(partTwo())")
}
