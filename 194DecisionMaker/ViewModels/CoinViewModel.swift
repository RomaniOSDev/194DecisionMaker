import SwiftUI
import Combine

@MainActor
final class CoinViewModel: ObservableObject {
    @Published var isFlipping = false
    @Published var result: CoinSide?
    @Published var showResult = false
    @Published var rotation: Double = 0

    private let storageService: StorageServiceProtocol
    private let coinEngine: CoinEngine
    private let coordinator: AppCoordinator

    init(
        storageService: StorageServiceProtocol,
        coinEngine: CoinEngine,
        coordinator: AppCoordinator
    ) {
        self.storageService = storageService
        self.coinEngine = coinEngine
        self.coordinator = coordinator
    }

    func flip() {
        guard !isFlipping else { return }

        isFlipping = true
        showResult = false
        result = nil

        let randomRotation = Double.random(in: 720...1080)
        withAnimation(.easeOut(duration: 1.5)) {
            rotation += randomRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { [weak self] in
            guard let self else { return }
            self.result = self.coinEngine.flip()
            self.showResult = true
            self.isFlipping = false

            if let result = self.result {
                self.saveDecision(result: result)
            }
        }
    }

    private func saveDecision(result: CoinSide) {
        let history = DecisionHistory(
            id: UUID(),
            optionText: result.rawValue,
            optionEmoji: result.emoji,
            mode: .coin,
            date: Date(),
            isFavorite: false
        )
        DecisionRecorder.record(
            history: history,
            mode: .coin,
            optionID: nil,
            storageService: storageService
        )
    }

    func dismissResult() {
        showResult = false
        result = nil
    }

    func goBack() {
        coordinator.pop()
    }
}
