import Foundation

enum DecisionRecorder {
    static func record(
        history: DecisionHistory,
        mode: DecisionMode,
        optionID: UUID?,
        storageService: StorageServiceProtocol
    ) {
        storageService.append(history, forKey: StorageKeys.history)

        var stats: Statistics = storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
        stats.totalDecisions += 1

        switch mode {
        case .wheel: stats.wheelDecisions += 1
        case .coin: stats.coinDecisions += 1
        case .dice: stats.diceDecisions += 1
        case .elimination: stats.eliminationDecisions += 1
        case .guided: stats.guidedDecisions += 1
        case .bracket: stats.bracketDecisions += 1
        }

        let today = DateFormatter.yyyyMMdd.string(from: Date())
        stats.dailyStats[today] = (stats.dailyStats[today] ?? 0) + 1

        let week = DateFormatter.yyyyWW.string(from: Date())
        stats.weeklyStats[week] = (stats.weeklyStats[week] ?? 0) + 1

        if let category = history.collectionCategory {
            let key = category.rawValue
            stats.collectionDecisionCounts[key] = (stats.collectionDecisionCounts[key] ?? 0) + 1
        }

        let historyItems: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        var optionUsage: [String: Int] = [:]
        for item in historyItems {
            optionUsage[item.optionText] = (optionUsage[item.optionText] ?? 0) + 1
        }
        stats.mostUsedOption = optionUsage.max(by: { $0.value < $1.value })?.key
        stats.favoriteOption = stats.mostUsedOption

        storageService.saveObject(stats, forKey: StorageKeys.statistics)

        if let optionID {
            var allOptions: [Option] = storageService.load(forKey: StorageKeys.options)
            if let index = allOptions.firstIndex(where: { $0.id == optionID }) {
                allOptions[index].usageCount += 1
                allOptions[index].lastPickedAt = Date()
                storageService.save(allOptions, forKey: StorageKeys.options)
            }
        }
    }

    static func updateJournal(
        historyId: UUID,
        satisfaction: SatisfactionRating?,
        note: String?,
        storageService: StorageServiceProtocol
    ) {
        var history: [DecisionHistory] = storageService.load(forKey: StorageKeys.history)
        guard let index = history.firstIndex(where: { $0.id == historyId }) else { return }

        history[index].satisfaction = satisfaction
        history[index].note = note?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? nil : note
        storageService.save(history, forKey: StorageKeys.history)

        guard let satisfaction,
              let category = history[index].collectionCategory?.rawValue else { return }

        var stats: Statistics = storageService.loadObject(forKey: StorageKeys.statistics) ?? .empty
        var categoryStats = stats.satisfactionByCategory[category] ?? CategorySatisfaction(positive: 0, negative: 0)

        switch satisfaction {
        case .positive: categoryStats.positive += 1
        case .negative: categoryStats.negative += 1
        }

        stats.satisfactionByCategory[category] = categoryStats
        storageService.saveObject(stats, forKey: StorageKeys.statistics)
    }

    static func collectionCategory(
        for option: Option,
        storageService: StorageServiceProtocol
    ) -> CollectionCategory? {
        guard let collectionId = option.collectionId else { return nil }
        let collections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        return collections.first { $0.id == collectionId }?.category
    }

    static func makeHistory(
        option: Option,
        mode: DecisionMode,
        storageService: StorageServiceProtocol
    ) -> DecisionHistory {
        DecisionHistory(
            optionText: option.text,
            optionEmoji: option.emoji,
            mode: mode,
            optionId: option.id,
            collectionId: option.collectionId,
            collectionCategory: collectionCategory(for: option, storageService: storageService)
        )
    }
}
