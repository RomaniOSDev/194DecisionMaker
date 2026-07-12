import Foundation
import SwiftUI

struct WheelSegment {
    let option: Option
    let startAngle: Double
    let endAngle: Double
    let color: Color
}

final class WheelEngine {
    func spin(options: [Option]) -> Option? {
        weightedPick(from: options)
    }

    func weightedPick(from options: [Option]) -> Option? {
        guard !options.isEmpty else { return nil }
        let totalWeight = options.reduce(0) { $0 + $1.effectiveWeight }
        guard totalWeight > 0 else { return options.randomElement() }

        var roll = Int.random(in: 0..<totalWeight)
        for option in options {
            roll -= option.effectiveWeight
            if roll < 0 { return option }
        }
        return options.last
    }

    func getSegments(options: [Option]) -> [WheelSegment] {
        guard !options.isEmpty else { return [] }
        let totalWeight = options.reduce(0) { $0 + $1.effectiveWeight }
        var currentAngle = 0.0

        return options.map { option in
            let slice = 360.0 * Double(option.effectiveWeight) / Double(totalWeight)
            let segment = WheelSegment(
                option: option,
                startAngle: currentAngle,
                endAngle: currentAngle + slice,
                color: Color(hex: option.color)
            )
            currentAngle += slice
            return segment
        }
    }

    /// Computes final rotation so the winner's slice center stops under the top pointer.
    func targetRotationAngle(
        for winner: Option,
        segments: [WheelSegment],
        currentRotation: Double,
        minSpins: Int = 5,
        maxSpins: Int = 8
    ) -> Double {
        guard let segment = segments.first(where: { $0.option.id == winner.id }) else {
            return currentRotation + 2160
        }

        let midAngle = (segment.startAngle + segment.endAngle) / 2
        let currentMod = currentRotation.truncatingRemainder(dividingBy: 360)
        var delta = midAngle - currentMod
        while delta <= 0 { delta += 360 }
        if delta < 60 { delta += 360 }

        let spins = Double(Int.random(in: minSpins...maxSpins))
        return currentRotation + spins * 360 + delta
    }
}
