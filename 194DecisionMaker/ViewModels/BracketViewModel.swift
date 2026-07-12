import SwiftUI
import Combine

@MainActor
final class BracketViewModel: ObservableObject {
    @Published var matches: [BracketMatch] = []
    @Published var currentRound = 1
    @Published var champion: Option?
    @Published var showJournal = false
    @Published var pendingHistoryId: UUID?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let bracketEngine: BracketEngine

    init(
        options: [Option],
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        bracketEngine: BracketEngine
    ) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.bracketEngine = bracketEngine
        matches = bracketEngine.buildInitialMatches(from: options)
        resolveByes()
    }

    var rounds: [Int] {
        Array(Set(matches.map(\.round))).sorted()
    }

    func matches(for round: Int) -> [BracketMatch] {
        matches.filter { $0.round == round }
    }

    var activeMatches: [BracketMatch] {
        matches.filter { $0.round == currentRound && $0.winner == nil }
    }

    func pickWinner(_ option: Option, in match: BracketMatch) {
        guard let index = matches.firstIndex(where: { $0.id == match.id }) else { return }
        matches[index].winner = option
        advanceIfNeeded()
    }

    func randomWinner(in match: BracketMatch) {
        guard let winner = bracketEngine.pickRandomWinner(for: match) else { return }
        pickWinner(winner, in: match)
    }

    private func resolveByes() {
        for index in matches.indices where matches[index].optionB == nil {
            matches[index].winner = matches[index].optionA
        }
    }

    private func advanceIfNeeded() {
        let roundMatches = matches.filter { $0.round == currentRound }
        guard roundMatches.allSatisfy({ $0.winner != nil }) else { return }

        let winners = roundMatches.compactMap(\.winner)
        if winners.count == 1 {
            champion = winners[0]
            recordWin(winners[0])
            return
        }

        matches.append(contentsOf: bracketEngine.advanceWinners(from: matches, round: currentRound))
        currentRound += 1
        resolveByes()
    }

    private func recordWin(_ option: Option) {
        let history = DecisionRecorder.makeHistory(
            option: option,
            mode: .bracket,
            storageService: storageService
        )
        pendingHistoryId = history.id
        DecisionRecorder.record(
            history: history,
            mode: .bracket,
            optionID: option.id,
            storageService: storageService
        )
        showJournal = true
    }

    func submitJournal(satisfaction: SatisfactionRating?, note: String?) {
        guard let pendingHistoryId else { return }
        DecisionRecorder.updateJournal(
            historyId: pendingHistoryId,
            satisfaction: satisfaction,
            note: note,
            storageService: storageService
        )
    }

    func goBack() { coordinator.pop() }
}
