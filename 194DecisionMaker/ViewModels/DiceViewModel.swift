import SwiftUI
import Combine

@MainActor
final class DiceViewModel: ObservableObject {
    @Published var options: [Option]
    @Published var sides: Int
    @Published var isRolling = false
    @Published var rollValue: Int?
    @Published var selectedOption: Option?
    @Published var showResult = false
    @Published var showJournal = false
    @Published var pendingHistoryId: UUID?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let diceEngine: DiceEngine

    init(
        options: [Option],
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        diceEngine: DiceEngine
    ) {
        self.options = options
        self.storageService = storageService
        self.coordinator = coordinator
        self.diceEngine = diceEngine
        self.sides = diceEngine.effectiveSides(optionCount: options.count, requestedSides: options.count)
    }

    var canRoll: Bool { !options.isEmpty && !isRolling }

    func roll() {
        guard canRoll else { return }
        isRolling = true
        showResult = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self else { return }
            let value = self.diceEngine.roll(sides: self.sides)
            let index = self.diceEngine.optionIndex(for: value, optionCount: self.options.count)
            let option = self.options[index]
            self.rollValue = value
            self.selectedOption = option
            self.showResult = true
            self.isRolling = false
            self.saveDecision(option: option)
        }
    }

    private func saveDecision(option: Option) {
        let history = DecisionRecorder.makeHistory(
            option: option,
            mode: .dice,
            storageService: storageService
        )
        pendingHistoryId = history.id
        DecisionRecorder.record(
            history: history,
            mode: .dice,
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
