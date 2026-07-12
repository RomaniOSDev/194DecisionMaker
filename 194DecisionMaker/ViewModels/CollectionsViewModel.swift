import SwiftUI
import Combine

@MainActor
final class CollectionsViewModel: ObservableObject {
    @Published var collections: [OptionCollection] = []
    @Published var options: [Option] = []

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        load()
    }

    func load() {
        collections = storageService.load(forKey: StorageKeys.collections)
            .sorted { $0.createdAt > $1.createdAt }
        options = storageService.load(forKey: StorageKeys.options)
    }

    func optionCount(for collection: OptionCollection) -> Int {
        options.filter { $0.collectionId == collection.id }.count
    }

    func collections(for category: CollectionCategory) -> [OptionCollection] {
        collections.filter { $0.category == category }
    }

    func createCollection(name: String, emoji: String, category: CollectionCategory) {
        let collection = OptionCollection(name: name, emoji: emoji, category: category)
        var all: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        all.append(collection)
        storageService.save(all, forKey: StorageKeys.collections)
        load()
    }

    func deleteCollection(_ collection: OptionCollection) {
        var allCollections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        allCollections.removeAll { $0.id == collection.id }
        storageService.save(allCollections, forKey: StorageKeys.collections)

        var allOptions: [Option] = storageService.load(forKey: StorageKeys.options)
        for index in allOptions.indices where allOptions[index].collectionId == collection.id {
            allOptions[index].collectionId = nil
        }
        storageService.save(allOptions, forKey: StorageKeys.options)
        load()
    }

    func openCollection(_ collection: OptionCollection) {
        coordinator.navigateToOptionList(collectionId: collection.id)
    }

    func addOption(to collection: OptionCollection) {
        coordinator.navigateToOptionForm(collectionId: collection.id)
    }

    func goBack() { coordinator.pop() }
}
