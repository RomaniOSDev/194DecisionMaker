import Foundation

struct SmartRules: Codable, Hashable {
    var noRepeatInRow: Bool
    var cooldownHours: Int
    var excludeRecentCount: Int

    static let `default` = SmartRules(
        noRepeatInRow: true,
        cooldownHours: 24,
        excludeRecentCount: 2
    )
}
