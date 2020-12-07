import Foundation

let rawBags = input.components(separatedBy: .newlines)

typealias NestedBag = (count: Int, name: String)
var bags = [String: [NestedBag]]()

for rawBag in rawBags {
    let parts = rawBag.components(separatedBy: "contain")

    let bagName = String(parts[0].dropLast()).replacingOccurrences(of: "bags", with: "bag")
    let rawNestedBags = parts[1]
        .dropLast()
        .split(separator: Character(","))
        .map { $0.dropFirst() }

    let nestedBags: [(Int, String)] = rawNestedBags
        .filter { $0 != "no other bags" }
        .map { rawBag -> (Int, String) in
            let components = rawBag.components(separatedBy: .whitespaces)
            let count = Int(components.first ?? "") ?? 0
            let name = components[1..<components.count].joined(separator: " ")
                .replacingOccurrences(of: "bags", with: "bag")
            return (count, name)
        }

    bags[bagName] = nestedBags
}

// MARK: - Part One

var containerBags: Set<String> = ["shiny gold bag"]
var count = 0

func findOuterBags(for containerBags: Set<String>) -> Set<String> {
    var containerBagsCopy = containerBags
    for container in containerBags {
        for bag in bags {
            if bag.value.contains(where: { $0.name == container }) {
                containerBagsCopy.insert(bag.key)
            }
        }
    }
    return containerBagsCopy
}

repeat {
    count = containerBags.count
    containerBags.formUnion(findOuterBags(for: containerBags))
} while containerBags.count > count

let answerPartOne = containerBags.count - 1
print("Answer Part One: \(answerPartOne)")

// MARK: - Part Two

func countBags(bagName: String) -> Int {

    guard let nestedBags = bags[bagName], !nestedBags.isEmpty else {
        return 0
    }

    return nestedBags.reduce(0) { count, nestedBag -> Int in
        count + nestedBag.count + nestedBag.count * countBags(bagName: nestedBag.name)
    }
}

let answerPartTwo = countBags(bagName: "shiny gold bag")
print("Answer Part Two: \(answerPartTwo)")
