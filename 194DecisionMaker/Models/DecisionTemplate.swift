import Foundation

struct DecisionTemplate: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let category: CollectionCategory
    let description: String
    let options: [TemplateOption]

    struct TemplateOption: Hashable {
        let text: String
        let emoji: String
        let color: String
        let weight: Int
        let estimatedMinutes: Int
        let budgetLevel: Int
        let isIndoor: Bool?
    }
}
