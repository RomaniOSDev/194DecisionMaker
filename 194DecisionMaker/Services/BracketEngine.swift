import Foundation

struct BracketMatch: Identifiable, Hashable {
    let id: UUID
    var optionA: Option?
    var optionB: Option?
    var winner: Option?
    var round: Int
}

final class BracketEngine {
    func buildInitialMatches(from options: [Option]) -> [BracketMatch] {
        let shuffled = options.shuffled()
        var matches: [BracketMatch] = []
        var index = 0
        var round = 1

        while index < shuffled.count {
            let a = shuffled[index]
            let b = index + 1 < shuffled.count ? shuffled[index + 1] : nil
            matches.append(BracketMatch(
                id: UUID(),
                optionA: a,
                optionB: b,
                winner: b == nil ? a : nil,
                round: round
            ))
            index += 2
        }
        return matches
    }

    func advanceWinners(from matches: [BracketMatch], round: Int) -> [BracketMatch] {
        let winners = matches.filter { $0.round == round }.compactMap(\.winner)
        guard winners.count > 1 else { return [] }

        var nextMatches: [BracketMatch] = []
        var index = 0
        while index < winners.count {
            let a = winners[index]
            let b = index + 1 < winners.count ? winners[index + 1] : nil
            nextMatches.append(BracketMatch(
                id: UUID(),
                optionA: a,
                optionB: b,
                winner: b == nil ? a : nil,
                round: round + 1
            ))
            index += 2
        }
        return nextMatches
    }

    func pickRandomWinner(for match: BracketMatch) -> Option? {
        switch (match.optionA, match.optionB) {
        case let (a?, b?): return Bool.random() ? a : b
        case let (a?, nil): return a
        case let (nil, b?): return b
        default: return nil
        }
    }
}
