import SwiftUI
import Combine

@MainActor
final class OptionFormViewModel: ObservableObject {
    @Published var text = ""
    @Published var selectedEmoji = "⭐"
    @Published var selectedColor = "#0277DB"
    @Published var isFavorite = false
    @Published var weight = 3
    @Published var estimatedMinutes = 60
    @Published var budgetLevel = 2
    @Published var indoorSetting = IndoorSetting.any
    @Published var selectedCollectionId: UUID?

    enum IndoorSetting: String, CaseIterable {
        case any = "Any"
        case indoor = "Indoor"
        case outdoor = "Outdoor"

        var value: Bool? {
            switch self {
            case .any: return nil
            case .indoor: return true
            case .outdoor: return false
            }
        }
    }

    let availableEmojis = [
        "⭐", "❤️", "🎯", "💪", "🌟", "🔥", "💡", "🎉", "✨", "🌈",
        "🎊", "🏆", "🍕", "🎸", "🚀", "🌺", "🎨", "🏀", "📚", "🎭",
        "🍀", "🌊", "🌅", "🎵", "💎"
    ]
    let availableColors = Option.defaultColors

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let editingOption: Option?
    private let defaultCollectionId: UUID?

    var collections: [OptionCollection] {
        storageService.load(forKey: StorageKeys.collections)
    }

    var isEditing: Bool { editingOption != nil }

    var isFormValid: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(
        option: Option? = nil,
        collectionId: UUID? = nil,
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator
    ) {
        self.editingOption = option
        self.defaultCollectionId = collectionId
        self.storageService = storageService
        self.coordinator = coordinator

        if let option {
            text = option.text
            selectedEmoji = option.emoji
            selectedColor = option.color
            isFavorite = option.isFavorite
            weight = option.weight
            estimatedMinutes = option.estimatedMinutes
            budgetLevel = option.budgetLevel
            selectedCollectionId = option.collectionId
            if let indoor = option.isIndoor {
                indoorSetting = indoor ? .indoor : .outdoor
            }
        } else {
            selectedCollectionId = collectionId
        }
    }

    func saveOption() {
        guard isFormValid else { return }

        if isEditing, let option = editingOption {
            var updated = option
            updated.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            updated.emoji = selectedEmoji
            updated.color = selectedColor
            updated.isFavorite = isFavorite
            updated.weight = weight
            updated.estimatedMinutes = estimatedMinutes
            updated.budgetLevel = budgetLevel
            updated.isIndoor = indoorSetting.value
            updated.collectionId = selectedCollectionId
            storageService.update(updated, forKey: StorageKeys.options)
        } else {
            let newOption = Option(
                text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                emoji: selectedEmoji,
                color: selectedColor,
                isFavorite: isFavorite,
                weight: weight,
                collectionId: selectedCollectionId ?? defaultCollectionId,
                estimatedMinutes: estimatedMinutes,
                budgetLevel: budgetLevel,
                isIndoor: indoorSetting.value
            )
            storageService.append(newOption, forKey: StorageKeys.options)
        }

        coordinator.pop()
    }

    func cancel() { coordinator.pop() }
}
