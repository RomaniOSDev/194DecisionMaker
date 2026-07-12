import SwiftUI
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {
    @Published var statistics: Statistics
    @Published var topOptions: [(String, Int)] = []
    @Published var dailyData: [(String, Int)] = []
    @Published var categoryStats: [(String, CategorySatisfaction)] = []

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    var totalDecisions: Int { statistics.totalDecisions }
    var wheelDecisions: Int { statistics.wheelDecisions }
    var coinDecisions: Int { statistics.coinDecisions }
    var diceDecisions: Int { statistics.diceDecisions }
    var eliminationDecisions: Int { statistics.eliminationDecisions }
    var guidedDecisions: Int { statistics.guidedDecisions }
    var bracketDecisions: Int { statistics.bracketDecisions }
    var favoriteOption: String? { statistics.favoriteOption }
    var mostUsedOption: String? { statistics.mostUsedOption }

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.statistics = storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
        loadStats()
    }

    func loadStats() {
        statistics = storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
        let history: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)

        var usage: [String: Int] = [:]
        for item in history {
            usage[item.optionText] = (usage[item.optionText] ?? 0) + 1
        }
        topOptions = usage.sorted { $0.value > $1.value }.prefix(5).map { ($0.key, $0.value) }

        let calendar = Calendar.current
        let today = Date()
        var daily: [(String, Int)] = []
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let key = DateFormatter.yyyyMMdd.string(from: date)
                let count = statistics.dailyStats[key] ?? 0
                let label = DateFormatter.shortDay.string(from: date)
                daily.append((label, count))
            }
        }
        dailyData = daily.reversed()

        categoryStats = statistics.satisfactionByCategory
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value) }
    }

    func goBack() { coordinator.pop() }
}
