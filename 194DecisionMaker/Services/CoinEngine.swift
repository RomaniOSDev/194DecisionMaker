import Foundation

enum CoinSide: String, Codable {
    case heads = "Heads"
    case tails = "Tails"

    var emoji: String { "🪙" }
}

final class CoinEngine {
    func flip() -> CoinSide {
        Bool.random() ? .heads : .tails
    }
}
