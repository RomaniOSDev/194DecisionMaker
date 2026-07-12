import Foundation

enum CollectionCategory: String, CaseIterable, Codable, Hashable {
    case food = "Food"
    case travel = "Travel"
    case work = "Work"
    case custom = "Custom"

    var icon: String {
        switch self {
        case .food: return "🍽️"
        case .travel: return "✈️"
        case .work: return "💼"
        case .custom: return "📁"
        }
    }
}

struct OptionCollection: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var emoji: String
    var category: CollectionCategory
    var createdAt: Date
    var isTemplate: Bool

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        category: CollectionCategory,
        createdAt: Date = Date(),
        isTemplate: Bool = false
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.category = category
        self.createdAt = createdAt
        self.isTemplate = isTemplate
    }
}
