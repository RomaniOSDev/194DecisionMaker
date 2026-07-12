import SwiftUI
import Combine

@MainActor
final class OptionListViewModel: ObservableObject {
    @Published var options: [Option] = []
    @Published var searchText = ""

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let collectionId: UUID?

    var filteredOptions: [Option] {
        var result = options
        if let collectionId {
            result = result.filter { $0.collectionId == collectionId }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    init(
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        collectionId: UUID? = nil
    ) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.collectionId = collectionId
        loadOptions()
    }

    func loadOptions() {
        options = storageService.load(forKey: StorageKeys.options)
            .sorted { $0.createdAt > $1.createdAt }
    }

    func deleteOption(_ option: Option) {
        var allOptions: [Option] = storageService.load(forKey: StorageKeys.options)
        allOptions.removeAll { $0.id == option.id }
        storageService.save(allOptions, forKey: StorageKeys.options)
        loadOptions()
    }

    func toggleFavorite(_ option: Option) {
        var allOptions: [Option] = storageService.load(forKey: StorageKeys.options)
        if let index = allOptions.firstIndex(where: { $0.id == option.id }) {
            allOptions[index].isFavorite.toggle()
            storageService.save(allOptions, forKey: StorageKeys.options)
            loadOptions()
        }
    }

    func goToOptionForm(option: Option? = nil) {
        coordinator.navigateToOptionForm(option: option, collectionId: collectionId)
    }

    func goBack() { coordinator.pop() }
}
