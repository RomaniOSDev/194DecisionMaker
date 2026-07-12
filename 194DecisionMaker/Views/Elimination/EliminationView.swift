import SwiftUI

struct EliminationView: View {
  @StateObject private var viewModel: EliminationViewModel

  init(viewModel: EliminationViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(
            emoji: "⚔️",
            title: "Elimination",
            subtitle: viewModel.isComplete ? "We have a winner!" : "Round \(viewModel.currentRound) — pick the winner"
          )

          if let champion = viewModel.champion {
            ResultBanner(
              emoji: champion.emoji,
              title: champion.text,
              subtitle: "Tournament champion",
              accent: Color(hex: "FF6B6B")
            )
          } else {
            ForEach(viewModel.activeMatches) { match in
              MatchCell(
                match: match,
                onPick: { viewModel.pickWinner($0, in: match) },
                onRandom: { viewModel.autoPick(in: match) }
              )
            }
          }

          Spacer(minLength: 24)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .sheet(isPresented: $viewModel.showJournal) {
      if let id = viewModel.pendingHistoryId, let champion = viewModel.champion {
        JournalFeedbackSheet(
          isPresented: $viewModel.showJournal,
          title: "\(champion.emoji) \(champion.text)",
          historyId: id,
          onSubmit: viewModel.submitJournal
        )
      }
    }
  }
}
