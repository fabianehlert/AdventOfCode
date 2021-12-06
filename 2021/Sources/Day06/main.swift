import Foundation
import Utilities

let initialState = input.components(separatedBy: ",").compactMap(Int.init)

// MARK: - Part 1 + 2

func simulateGrowth(days: Int) -> Int {
    var fish = Array(repeating: 0, count: 9)

    for state in initialState {
        fish[state] += 1
    }

    for _ in 0..<days {
        var spawned = Array(repeating: 0, count: 9)
        for i in 0..<8 {
            spawned[i] = fish[i+1]
        }
        spawned[8] = fish[0]
        spawned[6] += fish[0]
        fish = spawned
    }

    return fish.reduce(0, +)
}

print("Answer Part 1: \(simulateGrowth(days: 80))")
print("Answer Part 2: \(simulateGrowth(days: 256))")
