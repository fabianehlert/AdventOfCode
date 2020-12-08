import Foundation

enum Termination {
    case loop(accumulator: Int)
    case ended(accumulator: Int)
}

enum Instruction {
    case acc(Int)
    case jmp(Int)
    case nop(Int)

    init(_ raw: String) {
        let parts = raw.split(separator: Character(" "))
        switch parts[0] {
        case "acc":
            self = .acc(Int(parts[1])!)
        case "jmp":
            self = .jmp(Int(parts[1])!)
        case "nop":
            self = .nop(Int(parts[1])!)
        default:
            preconditionFailure("Unknown instruction: \(raw)")
        }
    }
}

extension Array where Element == Instruction {

    mutating func toggleJmpNop(at index: Int) {
        switch self[index] {
        case .jmp(let offset):
            self[index] = Instruction.nop(offset)
        case .nop(let offset):
            self[index] = Instruction.jmp(offset)
        default:
            break
        }
    }
}

let instructions = input
    .components(separatedBy: .newlines)
    .map(Instruction.init)

func run(instructions: [Instruction]) -> Termination {
    var index = 0
    var accumulator = 0
    var visited: Set<Int> = [index]

    while true {
        let instruction = instructions[index]
        var nextIndex = index

        switch instruction {
        case .acc(let offset):
            accumulator += offset
            nextIndex += 1
        case .jmp(let offset):
            nextIndex += offset
        case .nop:
            nextIndex += 1
        }

        if visited.contains(nextIndex) {
            return .loop(accumulator: accumulator)
        } else if nextIndex >= instructions.count {
            return .ended(accumulator: accumulator)
        } else {
            visited.insert(nextIndex)
            index = nextIndex
        }
    }
}

// MARK: - Part One

func partOne(instructions: [Instruction]) -> Int {
    if case let Termination.loop(accumulator) = run(instructions: instructions) {
        return accumulator
    }
    return 0
}

print("Answer Part One: \(partOne(instructions: instructions))")

// MARK: - Part Two

func partTwo(instructions: [Instruction]) -> Int {
    for (offset, _) in instructions.enumerated() {
        var modifiedInstructions = instructions
        modifiedInstructions.toggleJmpNop(at: offset)

        if case let Termination.ended(accumulator) = run(instructions: modifiedInstructions) {
            return accumulator
        }
    }
    return 0
}

print("Answer Part Two: \(partTwo(instructions: instructions))")
