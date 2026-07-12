import Foundation

enum DecisionMode: String, CaseIterable, Codable, Hashable {
    case wheel = "Wheel"
    case coin = "Coin"
    case dice = "Dice"
    case elimination = "Elimination"
    case guided = "Guided"
    case bracket = "Bracket"

    var icon: String {
        switch self {
        case .wheel: return "🎡"
        case .coin: return "🪙"
        case .dice: return "🎲"
        case .elimination: return "⚔️"
        case .guided: return "🧭"
        case .bracket: return "🏆"
        }
    }
}
