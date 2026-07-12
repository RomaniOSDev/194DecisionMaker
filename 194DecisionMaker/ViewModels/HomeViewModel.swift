import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var options: [Option] = []
    @Published var collections: [OptionCollection] = []
    @Published var recentDecisions: [DecisionHistory] = []
    @Published var statistics: Statistics

    private let storageService: StorageServiceProtocol
    let coordinator: AppCoordinator

    var hasOptions: Bool { !options.isEmpty }
    var totalDecisions: Int { statistics.totalDecisions }
    var totalOptions: Int { options.count }

    init(storageService: StorageServiceProtocol? = nil, coordinator: AppCoordinator) {
        self.coordinator = coordinator
        self.storageService = storageService ?? coordinator.storageService
        self.statistics = self.storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
        loadData()
    }

    func loadData() {
        options = storageService.load(forKey: StorageKeys.options)
        collections = storageService.load(forKey: StorageKeys.collections)
        let history: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        recentDecisions = Array(history.sorted { $0.date > $1.date }.prefix(5))
        statistics = storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
    }

    func startWheel() {
        guard hasOptions else { return }
        coordinator.navigateToWheel()
    }

    func startCoin() { coordinator.navigateToCoin() }
    func startDice() {
        guard hasOptions else { return }
        coordinator.navigateToDice()
    }
    func startElimination() {
        guard options.count >= 2 else { return }
        coordinator.navigateToElimination()
    }
    func startBracket() {
        guard options.count >= 2 else { return }
        coordinator.navigateToBracket()
    }
    func startGuided() {
        guard hasOptions else { return }
        coordinator.navigateToGuidedFlow()
    }

    func goToCollections() { coordinator.navigateToCollections() }
    func goToTemplates() { coordinator.navigateToTemplates() }
    func goToOptionList() { coordinator.navigateToOptionList() }
    func goToOptionForm() { coordinator.navigateToOptionForm() }
    func goToHistory() { coordinator.navigateToHistory() }
    func goToStatistics() { coordinator.navigateToStatistics() }
    func goToSettings() { coordinator.navigateToSettings() }
}
