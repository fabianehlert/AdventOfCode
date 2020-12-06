import Foundation
import Utilities

measure {
    let groups = input
        .components(separatedBy: "\n\n")
        .map { $0.components(separatedBy: .newlines) }

    // MARK: - Part One

    let positiveAnswersPerGroup = groups.map { group -> Int in
        let individualAnswers = group.flatMap { Array($0) }
        return Set(individualAnswers).count
    }

    let answerPartOne = positiveAnswersPerGroup.reduce(0, +)
    print("Answer Part One: \(answerPartOne)")

    // MARK: - Part Two

    let intersectingAnswersPerGroup = groups.map { group -> Int in

        // Find shortest string as it indicates the maximum number of possible intersections.
        guard let shortestGroup = group
                .sorted(by: { $0.count < $1.count })
                .first
        else {
            return 0
        }

        var intersectingAnswers = Set(shortestGroup)
        group.forEach { answers in
            intersectingAnswers.formIntersection(answers)
        }

        return intersectingAnswers.count
    }

    let answerPartTwo = intersectingAnswersPerGroup.reduce(0, +)
    print("Answer Part Two: \(answerPartTwo)")
}
