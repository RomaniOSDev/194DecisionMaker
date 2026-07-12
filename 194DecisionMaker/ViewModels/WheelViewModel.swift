import SwiftUI
import Combine
import UIKit

@MainActor
final class WheelViewModel: ObservableObject {
    @Published var options: [Option]
    @Published var isSpinning = false
    @Published var selectedOption: Option?
    @Published var showResult = false
    @Published var rotationAngle: Double = 0
    @Published var segments: [WheelSegment] = []
    @Published var showJournal = false
    @Published var pendingHistoryId: UUID?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let wheelEngine: WheelEngine
    private let filterService: OptionFilterService
    let decisionMode: DecisionMode

    private let spinDuration: TimeInterval = 3.8

    init(
        options: [Option],
        mode: DecisionMode = .wheel,
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        wheelEngine: WheelEngine,
        filterService: OptionFilterService
    ) {
        self.options = options
        self.decisionMode = mode
        self.storageService = storageService
        self.coordinator = coordinator
        self.wheelEngine = wheelEngine
        self.filterService = filterService
        self.segments = wheelEngine.getSegments(options: options)
    }

    func spin() {
        guard !isSpinning, !options.isEmpty else { return }
        guard let winner = wheelEngine.spin(options: options) else { return }

        isSpinning = true
        showResult = false
        selectedOption = nil

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let targetAngle = wheelEngine.targetRotationAngle(
            for: winner,
            segments: segments,
            currentRotation: rotationAngle
        )

        withAnimation(.timingCurve(0.12, 0.86, 0.18, 1.0, duration: spinDuration)) {
            rotationAngle = targetAngle
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration + 0.2) { [weak self] in
            guard let self else { return }
            self.selectedOption = winner
            self.showResult = true
            self.isSpinning = false
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.saveDecision(option: winner)
        }
    }

    private func saveDecision(option: Option) {
        let history = DecisionRecorder.makeHistory(
            option: option,
            mode: decisionMode,
            storageService: storageService
        )
        pendingHistoryId = history.id
        DecisionRecorder.record(
            history: history,
            mode: decisionMode,
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

    func dismissResult() {
        showResult = false
        selectedOption = nil
    }

    func goBack() { coordinator.pop() }
}
