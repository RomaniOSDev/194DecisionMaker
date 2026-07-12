import Foundation

struct Option: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var emoji: String
    var color: String
    var createdAt: Date
    var isFavorite: Bool
    var usageCount: Int
    var weight: Int
    var collectionId: UUID?
    var estimatedMinutes: Int
    var budgetLevel: Int
    var isIndoor: Bool?
    var lastPickedAt: Date?

    init(
        id: UUID = UUID(),
        text: String,
        emoji: String,
        color: String,
        createdAt: Date = Date(),
        isFavorite: Bool = false,
        usageCount: Int = 0,
        weight: Int = 3,
        collectionId: UUID? = nil,
        estimatedMinutes: Int = 60,
        budgetLevel: Int = 2,
        isIndoor: Bool? = nil,
        lastPickedAt: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.emoji = emoji
        self.color = color
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.usageCount = usageCount
        self.weight = min(5, max(1, weight))
        self.collectionId = collectionId
        self.estimatedMinutes = estimatedMinutes
        self.budgetLevel = min(3, max(1, budgetLevel))
        self.isIndoor = isIndoor
        self.lastPickedAt = lastPickedAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        text = try c.decode(String.self, forKey: .text)
        emoji = try c.decode(String.self, forKey: .emoji)
        color = try c.decode(String.self, forKey: .color)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        isFavorite = try c.decode(Bool.self, forKey: .isFavorite)
        usageCount = try c.decode(Int.self, forKey: .usageCount)
        weight = min(5, max(1, try c.decodeIfPresent(Int.self, forKey: .weight) ?? 3))
        collectionId = try c.decodeIfPresent(UUID.self, forKey: .collectionId)
        estimatedMinutes = try c.decodeIfPresent(Int.self, forKey: .estimatedMinutes) ?? 60
        budgetLevel = min(3, max(1, try c.decodeIfPresent(Int.self, forKey: .budgetLevel) ?? 2))
        isIndoor = try c.decodeIfPresent(Bool.self, forKey: .isIndoor)
        lastPickedAt = try c.decodeIfPresent(Date.self, forKey: .lastPickedAt)
    }
}

extension Option {
    static let defaultColors: [String] = [
        "#0277DB", "#FF6B6B", "#FFD93D", "#6BCB77",
        "#A29BFE", "#FD79A8", "#FDCB6E", "#00B894",
        "#74B9FF", "#E17055", "#6C5CE7", "#00CEC9"
    ]

    static let defaultEmojis: [String] = [
        "⭐", "❤️", "🎯", "💪", "🌟", "🔥",
        "💡", "🎉", "✨", "🌈", "🎊", "🏆"
    ]

    var effectiveWeight: Int { min(5, max(1, weight)) }
}
