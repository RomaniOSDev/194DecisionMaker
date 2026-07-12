import Foundation

enum SatisfactionRating: String, Codable, Hashable {
    case positive
    case negative

    var emoji: String {
        switch self {
        case .positive: return "👍"
        case .negative: return "👎"
        }
    }
}

struct CategorySatisfaction: Codable, Hashable {
    var positive: Int
    var negative: Int

    var total: Int { positive + negative }

    var satisfactionPercent: Int {
        guard total > 0 else { return 0 }
        return Int((Double(positive) / Double(total)) * 100)
    }
}
