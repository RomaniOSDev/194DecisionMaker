import Foundation

struct Statistics: Codable {
    var totalDecisions: Int
    var wheelDecisions: Int
    var coinDecisions: Int
    var diceDecisions: Int
    var eliminationDecisions: Int
    var guidedDecisions: Int
    var bracketDecisions: Int
    var favoriteOption: String?
    var mostUsedOption: String?
    var dailyStats: [String: Int]
    var weeklyStats: [String: Int]
    var satisfactionByCategory: [String: CategorySatisfaction]
    var collectionDecisionCounts: [String: Int]

    static let empty = Statistics(
        totalDecisions: 0,
        wheelDecisions: 0,
        coinDecisions: 0,
        diceDecisions: 0,
        eliminationDecisions: 0,
        guidedDecisions: 0,
        bracketDecisions: 0,
        favoriteOption: nil,
        mostUsedOption: nil,
        dailyStats: [:],
        weeklyStats: [:],
        satisfactionByCategory: [:],
        collectionDecisionCounts: [:]
    )

    init(
        totalDecisions: Int,
        wheelDecisions: Int,
        coinDecisions: Int,
        diceDecisions: Int = 0,
        eliminationDecisions: Int = 0,
        guidedDecisions: Int = 0,
        bracketDecisions: Int = 0,
        favoriteOption: String?,
        mostUsedOption: String?,
        dailyStats: [String: Int],
        weeklyStats: [String: Int],
        satisfactionByCategory: [String: CategorySatisfaction] = [:],
        collectionDecisionCounts: [String: Int] = [:]
    ) {
        self.totalDecisions = totalDecisions
        self.wheelDecisions = wheelDecisions
        self.coinDecisions = coinDecisions
        self.diceDecisions = diceDecisions
        self.eliminationDecisions = eliminationDecisions
        self.guidedDecisions = guidedDecisions
        self.bracketDecisions = bracketDecisions
        self.favoriteOption = favoriteOption
        self.mostUsedOption = mostUsedOption
        self.dailyStats = dailyStats
        self.weeklyStats = weeklyStats
        self.satisfactionByCategory = satisfactionByCategory
        self.collectionDecisionCounts = collectionDecisionCounts
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        totalDecisions = try c.decode(Int.self, forKey: .totalDecisions)
        wheelDecisions = try c.decode(Int.self, forKey: .wheelDecisions)
        coinDecisions = try c.decode(Int.self, forKey: .coinDecisions)
        diceDecisions = try c.decodeIfPresent(Int.self, forKey: .diceDecisions) ?? 0
        eliminationDecisions = try c.decodeIfPresent(Int.self, forKey: .eliminationDecisions) ?? 0
        guidedDecisions = try c.decodeIfPresent(Int.self, forKey: .guidedDecisions) ?? 0
        bracketDecisions = try c.decodeIfPresent(Int.self, forKey: .bracketDecisions) ?? 0
        favoriteOption = try c.decodeIfPresent(String.self, forKey: .favoriteOption)
        mostUsedOption = try c.decodeIfPresent(String.self, forKey: .mostUsedOption)
        dailyStats = try c.decodeIfPresent([String: Int].self, forKey: .dailyStats) ?? [:]
        weeklyStats = try c.decodeIfPresent([String: Int].self, forKey: .weeklyStats) ?? [:]
        satisfactionByCategory = try c.decodeIfPresent([String: CategorySatisfaction].self, forKey: .satisfactionByCategory) ?? [:]
        collectionDecisionCounts = try c.decodeIfPresent([String: Int].self, forKey: .collectionDecisionCounts) ?? [:]
    }
}
