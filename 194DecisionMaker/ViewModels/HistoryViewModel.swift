import SwiftUI
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var history: [DecisionHistory] = []
    @Published var filterMode: DecisionMode?
    @Published var showFavoritesOnly = false

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    var filteredHistory: [DecisionHistory] {
        var result = history

        if showFavoritesOnly {
            result = result.filter(\.isFavorite)
        }

        if let mode = filterMode {
            result = result.filter { $0.mode == mode }
        }

        return result.sorted { $0.date > $1.date }
    }

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        loadHistory()
    }

    func loadHistory() {
        history = storageService.load(forKey: StorageKeys.history)
    }

    func deleteHistory(_ item: DecisionHistory) {
        var allHistory: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        allHistory.removeAll { $0.id == item.id }
        storageService.save(allHistory, forKey: StorageKeys.history)
        loadHistory()
    }

    func toggleFavorite(_ item: DecisionHistory) {
        var allHistory: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        if let index = allHistory.firstIndex(where: { $0.id == item.id }) {
            allHistory[index].isFavorite.toggle()
            storageService.save(allHistory, forKey: StorageKeys.history)
            loadHistory()
        }
    }

    func clearHistory() {
        storageService.delete(forKey: StorageKeys.history)
        loadHistory()
    }

    func goBack() {
        coordinator.pop()
    }
}
