import Foundation
import Utilities

struct Line {

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
    }

    let start: Coordinate
    let end: Coordinate

    var isVertical: Bool {
        self.start.x == self.end.x
    }

    var isHorizontal: Bool {
        self.start.y == self.end.y
    }

    var isDiagnonal: Bool {
        !self.isVertical && !self.isHorizontal
    }

    init(raw: String) {
        let coordinates = raw
            .replacingOccurrences(of: " ", with: "")
            .components(separatedBy: "->")

        let x1y1 = coordinates[0].components(separatedBy: ",")
        let x2y2 = coordinates[1].components(separatedBy: ",")

        self.start = Coordinate(x: Int(x1y1[0])!, y: Int(x1y1[1])!)
        self.end = Coordinate(x: Int(x2y2[0])!, y: Int(x2y2[1])!)
    }
}

let puzzle = input.components(separatedBy: .newlines).map(Line.init)
var coordinateSystem = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
var coordinatesWithIntersection = Set<Line.Coordinate>()

// MARK: - Part 1

func part1() -> Int {
    for line in puzzle {
        if line.isVertical {
            let x = line.start.x
            let y1 = line.start.y
            let y2 = line.end.y
            for y in min(y1, y2)...max(y1, y2) {
                coordinateSystem[y][x] += 1
                if coordinateSystem[y][x] >= 2 {
                    coordinatesWithIntersection.insert(Line.Coordinate(x: x, y: y))
                }
            }
        } else if line.isHorizontal {
            let y = line.start.y
            let x1 = line.start.x
            let x2 = line.end.x
            for x in min(x1, x2)...max(x1, x2) {
                coordinateSystem[y][x] += 1
                if coordinateSystem[y][x] >= 2 {
                    coordinatesWithIntersection.insert(Line.Coordinate(x: x, y: y))
                }
            }
        }
    }
    return coordinatesWithIntersection.count
}

print("Answer 1: \(part1())")

// MARK: - Part 2

func part2() -> Int {
    for line in puzzle {
        if line.isDiagnonal {
            let start = line.start
            let end = line.end

            let minByX = [start, end].min(by: { $0.x < $1.x })!
            let maxByX = [start, end].max(by: { $0.x < $1.x })!

            var y = minByX.y
            let climbRate = (maxByX.y - minByX.y).signum()
            for x in minByX.x...maxByX.x {
                coordinateSystem[y][x] += 1
                if coordinateSystem[y][x] >= 2 {
                    coordinatesWithIntersection.insert(Line.Coordinate(x: x, y: y))
                }
                y += climbRate
            }
        }
    }
    return coordinatesWithIntersection.count
}

print("Answer 2: \(part2())")
