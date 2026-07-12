import Foundation

extension HomeViewModel {
  var greeting: String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5..<12: return "Good morning"
    case 12..<17: return "Good afternoon"
    case 17..<22: return "Good evening"
    default: return "Good night"
    }
  }

  var todayDecisions: Int {
    let key = DateFormatter.yyyyMMdd.string(from: Date())
    return statistics.dailyStats[key] ?? 0
  }

  var overallSatisfaction: Int? {
    let stats = statistics.satisfactionByCategory.values
    guard !stats.isEmpty else { return nil }
    let positive = stats.reduce(0) { $0 + $1.positive }
    let total = stats.reduce(0) { $0 + $1.total }
    guard total > 0 else { return nil }
    return Int((Double(positive) / Double(total)) * 100)
  }

  var weeklySparkline: [Int] {
    let calendar = Calendar.current
    let today = Date()
    return (0..<7).reversed().compactMap { offset -> Int? in
      guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
      let key = DateFormatter.yyyyMMdd.string(from: date)
      return statistics.dailyStats[key] ?? 0
    }
  }

  var favoriteModeLabel: String {
    let modes: [(String, Int)] = [
      ("Wheel", statistics.wheelDecisions),
      ("Coin", statistics.coinDecisions),
      ("Dice", statistics.diceDecisions),
      ("Guided", statistics.guidedDecisions)
    ]
    return modes.max(by: { $0.1 < $1.1 })?.0 ?? "Wheel"
  }

  var canSpin: Bool { hasOptions }
}
