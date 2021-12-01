import Foundation
import Utilities

let depths = input

// MARK: - Part 1

let depthPairs = zip(depths, Array(depths.dropFirst()))
var increaseCounter = 0

for depthPair in depthPairs {
    if (depthPair.1 - depthPair.0) > 0 {
        increaseCounter += 1
    }
}

print("Answer 1: \(increaseCounter)")

// MARK: - Part 2

increaseCounter = 0

for i in 1..<(depths.count - 2) {
    let lastSum = depths[i-1] + depths[i] + depths[i+1]
    let sum = depths[i] + depths[i+1] + depths[i+2]
    if (sum - lastSum) > 0 {
        increaseCounter += 1
    }
}

print("Answer 2: \(increaseCounter)")
