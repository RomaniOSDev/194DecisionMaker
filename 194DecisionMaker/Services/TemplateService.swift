import Foundation

final class TemplateService {
    static let shared = TemplateService()

    let templates: [DecisionTemplate] = [
        DecisionTemplate(
            id: "friday_dinner",
            name: "Friday Dinner",
            emoji: "🍕",
            category: .food,
            description: "Quick picks for Friday night dinner",
            options: [
                .init(text: "Pizza", emoji: "🍕", color: "#FF6B6B", weight: 4, estimatedMinutes: 45, budgetLevel: 2, isIndoor: true),
                .init(text: "Sushi", emoji: "🍣", color: "#0277DB", weight: 3, estimatedMinutes: 60, budgetLevel: 3, isIndoor: true),
                .init(text: "Burgers", emoji: "🍔", color: "#FFD93D", weight: 4, estimatedMinutes: 30, budgetLevel: 2, isIndoor: true),
                .init(text: "Thai", emoji: "🍜", color: "#6BCB77", weight: 3, estimatedMinutes: 50, budgetLevel: 2, isIndoor: true),
                .init(text: "Tacos", emoji: "🌮", color: "#E17055", weight: 3, estimatedMinutes: 40, budgetLevel: 2, isIndoor: true),
                .init(text: "Salad Bar", emoji: "🥗", color: "#00B894", weight: 2, estimatedMinutes: 30, budgetLevel: 1, isIndoor: true)
            ]
        ),
        DecisionTemplate(
            id: "weekend_activity",
            name: "Weekend Activity",
            emoji: "🎉",
            category: .travel,
            description: "Fun things to do on the weekend",
            options: [
                .init(text: "Hiking", emoji: "🥾", color: "#6BCB77", weight: 3, estimatedMinutes: 180, budgetLevel: 1, isIndoor: false),
                .init(text: "Museum", emoji: "🏛️", color: "#A29BFE", weight: 3, estimatedMinutes: 120, budgetLevel: 2, isIndoor: true),
                .init(text: "Beach", emoji: "🏖️", color: "#74B9FF", weight: 4, estimatedMinutes: 240, budgetLevel: 1, isIndoor: false),
                .init(text: "Movie", emoji: "🎬", color: "#6C5CE7", weight: 4, estimatedMinutes: 150, budgetLevel: 2, isIndoor: true),
                .init(text: "Bike Ride", emoji: "🚴", color: "#00CEC9", weight: 3, estimatedMinutes: 90, budgetLevel: 1, isIndoor: false),
                .init(text: "Game Night", emoji: "🎲", color: "#FD79A8", weight: 3, estimatedMinutes: 120, budgetLevel: 1, isIndoor: true)
            ]
        ),
        DecisionTemplate(
            id: "team_task_picker",
            name: "Team Task Picker",
            emoji: "💼",
            category: .work,
            description: "Fairly assign tasks across the team",
            options: [
                .init(text: "Write Report", emoji: "📝", color: "#0277DB", weight: 3, estimatedMinutes: 120, budgetLevel: 1, isIndoor: true),
                .init(text: "Client Call", emoji: "📞", color: "#FFD93D", weight: 3, estimatedMinutes: 30, budgetLevel: 1, isIndoor: true),
                .init(text: "Code Review", emoji: "💻", color: "#6BCB77", weight: 4, estimatedMinutes: 60, budgetLevel: 1, isIndoor: true),
                .init(text: "Presentation", emoji: "📊", color: "#FF6B6B", weight: 2, estimatedMinutes: 90, budgetLevel: 1, isIndoor: true),
                .init(text: "Research", emoji: "🔍", color: "#A29BFE", weight: 3, estimatedMinutes: 120, budgetLevel: 1, isIndoor: true),
                .init(text: "Standup Lead", emoji: "🎯", color: "#00B894", weight: 2, estimatedMinutes: 15, budgetLevel: 1, isIndoor: true)
            ]
        )
    ]

    func apply(
        template: DecisionTemplate,
        storageService: StorageServiceProtocol
    ) -> OptionCollection {
        let collection = OptionCollection(
            name: template.name,
            emoji: template.emoji,
            category: template.category,
            isTemplate: true
        )

        var collections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        collections.append(collection)
        storageService.save(collections, forKey: StorageKeys.collections)

        let options = template.options.enumerated().map { index, item in
            Option(
                text: item.text,
                emoji: item.emoji,
                color: item.color,
                weight: item.weight,
                collectionId: collection.id,
                estimatedMinutes: item.estimatedMinutes,
                budgetLevel: item.budgetLevel,
                isIndoor: item.isIndoor
            )
        }

        var existing: [Option] = storageService.load(forKey: StorageKeys.options)
        existing.append(contentsOf: options)
        storageService.save(existing, forKey: StorageKeys.options)

        return collection
    }
}
