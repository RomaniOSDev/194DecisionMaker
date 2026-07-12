import SwiftUI
import Combine

@MainActor
final class GuidedFlowViewModel: ObservableObject {
    @Published var maxMinutes = 60
    @Published var budgetLevel = 2
    @Published var indoorPreference = GuidedFlowCriteria.IndoorPreference.any
    @Published var filteredCount = 0

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let filterService: OptionFilterService

    let minuteOptions = [15, 30, 60, 120, 240]
    let budgetOptions: [(Int, String)] = [
        (1, "Low"),
        (2, "Medium"),
        (3, "High")
    ]

    init(
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        filterService: OptionFilterService
    ) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.filterService = filterService
        updatePreview()
    }

    func updatePreview() {
        let all: [Option] = storageService.load(forKey: StorageKeys.options)
        let criteria = GuidedFlowCriteria(
            maxMinutes: maxMinutes,
            budgetLevel: budgetLevel,
            indoorPreference: indoorPreference
        )
        filteredCount = filterService.filterForGuidedFlow(all, criteria: criteria).count
    }

    func startWheel() {
        let all: [Option] = storageService.load(forKey: StorageKeys.options)
        let history: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        let rules = filterService.loadRules(from: storageService)
        let rulesFiltered = filterService.eligibleOptions(
            all: all,
            rules: rules,
            history: history
        )
        let criteria = GuidedFlowCriteria(
            maxMinutes: maxMinutes,
            budgetLevel: budgetLevel,
            indoorPreference: indoorPreference
        )
        let guided = filterService.filterForGuidedFlow(rulesFiltered, criteria: criteria)
        let final = guided.isEmpty ? rulesFiltered : guided
        coordinator.navigateToWheel(options: final, mode: .guided)
    }

    func goBack() { coordinator.pop() }
}
