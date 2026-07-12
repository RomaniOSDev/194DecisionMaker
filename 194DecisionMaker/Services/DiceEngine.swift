import Foundation

final class DiceEngine {
    func roll(sides: Int) -> Int {
        guard sides >= 3 else { return 1 }
        return Int.random(in: 1...sides)
    }

    func optionIndex(for roll: Int, optionCount: Int) -> Int {
        guard optionCount > 0 else { return 0 }
        return (roll - 1) % optionCount
    }

    func effectiveSides(optionCount: Int, requestedSides: Int) -> Int {
        min(12, max(3, max(optionCount, requestedSides)))
    }
}
