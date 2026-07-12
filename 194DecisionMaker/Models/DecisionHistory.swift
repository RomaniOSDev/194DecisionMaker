import Foundation

struct DecisionHistory: Identifiable, Codable, Hashable {
    let id: UUID
    var optionText: String
    var optionEmoji: String
    var mode: DecisionMode
    var date: Date
    var isFavorite: Bool
    var optionId: UUID?
    var collectionId: UUID?
    var collectionCategory: CollectionCategory?
    var note: String?
    var satisfaction: SatisfactionRating?

    init(
        id: UUID = UUID(),
        optionText: String,
        optionEmoji: String,
        mode: DecisionMode,
        date: Date = Date(),
        isFavorite: Bool = false,
        optionId: UUID? = nil,
        collectionId: UUID? = nil,
        collectionCategory: CollectionCategory? = nil,
        note: String? = nil,
        satisfaction: SatisfactionRating? = nil
    ) {
        self.id = id
        self.optionText = optionText
        self.optionEmoji = optionEmoji
        self.mode = mode
        self.date = date
        self.isFavorite = isFavorite
        self.optionId = optionId
        self.collectionId = collectionId
        self.collectionCategory = collectionCategory
        self.note = note
        self.satisfaction = satisfaction
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        optionText = try c.decode(String.self, forKey: .optionText)
        optionEmoji = try c.decode(String.self, forKey: .optionEmoji)
        mode = try c.decode(DecisionMode.self, forKey: .mode)
        date = try c.decode(Date.self, forKey: .date)
        isFavorite = try c.decode(Bool.self, forKey: .isFavorite)
        optionId = try c.decodeIfPresent(UUID.self, forKey: .optionId)
        collectionId = try c.decodeIfPresent(UUID.self, forKey: .collectionId)
        collectionCategory = try c.decodeIfPresent(CollectionCategory.self, forKey: .collectionCategory)
        note = try c.decodeIfPresent(String.self, forKey: .note)
        satisfaction = try c.decodeIfPresent(SatisfactionRating.self, forKey: .satisfaction)
    }
}
