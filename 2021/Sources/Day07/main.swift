import Foundation
import Utilities

let crabPositions = input.components(separatedBy: ",").compactMap(Int.init)

// MARK: - Part 1 + 2

func findMostEfficientPosition() -> (part1: Int, part2: Int) {

    func fuelConsumption(for position: Int) -> (constantBurn: Int, increasingBurn: Int) {
        var fuelConstantBurn = 0
        var fuelIncreasingBurn = 0
        for otherPosition in crabPositions {
            let distance = abs(position - otherPosition)

            guard distance > 0 else { continue }

            fuelConstantBurn += distance
            fuelIncreasingBurn += (distance * (distance + 1)) / 2
        }
        return (fuelConstantBurn, fuelIncreasingBurn)
    }

    var optimumOne = (position: Int.max, fuel: Int.max)
    var optimumTwo = (position: Int.max, fuel: Int.max)

    for position in crabPositions.min()!...crabPositions.max()! {
        let fuel = fuelConsumption(for: position)
        if fuel.constantBurn < optimumOne.fuel {
            optimumOne = (position, fuel.constantBurn)
        }
        if fuel.increasingBurn < optimumTwo.fuel {
            optimumTwo = (position, fuel.increasingBurn)
        }
    }
    return (optimumOne.fuel, optimumTwo.fuel)
}

measure {
    let positions = findMostEfficientPosition()
    print("Answer 1: \(positions.part1)")
    print("Answer 2: \(positions.part2)")
}
