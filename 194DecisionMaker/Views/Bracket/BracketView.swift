import SwiftUI

struct BracketView: View {
  @StateObject private var viewModel: BracketViewModel

  init(viewModel: BracketViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: 0) {
        ScreenHeader(
          emoji: "🏆",
          title: "Tournament Bracket",
          subtitle: viewModel.champion == nil ? "Tap to advance winners" : "Champion crowned!"
        )
        .padding(.bottom, AppSpacing.md)

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(alignment: .top, spacing: AppSpacing.md) {
            ForEach(viewModel.rounds, id: \.self) { round in
              VStack(spacing: AppSpacing.sm) {
                Text(roundLabel(round))
                  .font(.caption.weight(.bold))
                  .foregroundColor(AppColor.accent)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(Capsule().fill(AppColor.accent.opacity(0.15)))

                ForEach(viewModel.matches(for: round)) { match in
                  BracketMatchCell(
                    match: match,
                    isActive: round == viewModel.currentRound,
                    onPick: { viewModel.pickWinner($0, in: match) },
                    onRandom: { viewModel.randomWinner(in: match) }
                  )
                }
              }
              .frame(width: 170)
            }
          }
          .padding(.horizontal, AppSpacing.lg)
          .padding(.bottom, AppSpacing.xl)
        }

        if let champion = viewModel.champion {
          ResultBanner(
            emoji: champion.emoji,
            title: champion.text,
            subtitle: "Bracket winner",
            accent: Color(hex: "A29BFE")
          )
          .padding(.horizontal, AppSpacing.lg)
          .padding(.bottom, AppSpacing.lg)
        }
      }
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

  private func roundLabel(_ round: Int) -> String {
    if viewModel.champion != nil, round == viewModel.rounds.last {
      return "Final"
    }
    return "R\(round)"
  }
}
