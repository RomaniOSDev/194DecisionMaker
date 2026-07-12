import Foundation

struct GuidedFlowCriteria: Hashable {
    var maxMinutes: Int
    var budgetLevel: Int
    var indoorPreference: IndoorPreference

    enum IndoorPreference: String, CaseIterable, Hashable {
        case any = "Any"
        case indoor = "Indoor"
        case outdoor = "Outdoor"
    }
}

final class OptionFilterService {
    func loadRules(from storage: StorageServiceProtocol) -> SmartRules {
        storage.loadObject(forKey: StorageKeys.smartRules) ?? .default
    }

    func eligibleOptions(
        all: [Option],
        rules: SmartRules,
        history: [DecisionHistory],
        collectionId: UUID? = nil
    ) -> [Option] {
        var pool = all
        if let collectionId {
            pool = pool.filter { $0.collectionId == collectionId }
        }
        guard !pool.isEmpty else { return all }

        let sortedHistory = history.sorted { $0.date > $1.date }

        if rules.noRepeatInRow, let last = sortedHistory.first {
            let filtered = pool.filter { $0.text != last.optionText }
            if !filtered.isEmpty { pool = filtered }
        }

        if rules.cooldownHours > 0 {
            let cutoff = Date().addingTimeInterval(-Double(rules.cooldownHours) * 3600)
            let filtered = pool.filter { option in
                guard let lastPicked = option.lastPickedAt else { return true }
                return lastPicked < cutoff
            }
            if !filtered.isEmpty { pool = filtered }
        }

        if rules.excludeRecentCount > 0 {
            let recentTexts = Set(
                sortedHistory.prefix(rules.excludeRecentCount).map(\.optionText)
            )
            let filtered = pool.filter { !recentTexts.contains($0.text) }
            if !filtered.isEmpty { pool = filtered }
        }

        return pool
    }

    func filterForGuidedFlow(_ options: [Option], criteria: GuidedFlowCriteria) -> [Option] {
        options.filter { option in
            guard option.estimatedMinutes <= criteria.maxMinutes else { return false }
            guard option.budgetLevel <= criteria.budgetLevel else { return false }

            switch criteria.indoorPreference {
            case .any: return true
            case .indoor: return option.isIndoor != false
            case .outdoor: return option.isIndoor != true
            }
        }
    }
}
