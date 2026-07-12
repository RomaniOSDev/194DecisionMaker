import SwiftUI

struct WheelView: View {
  @StateObject private var viewModel: WheelViewModel

  init(viewModel: WheelViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: AppSpacing.xl) {
        ScreenHeader(
          emoji: viewModel.decisionMode == .guided ? "🧭" : "🎡",
          title: viewModel.decisionMode == .guided ? "Guided Wheel" : "Weighted Wheel",
          subtitle: "Bigger slices win more often"
        )

        WheelOfFortuneView(
          segments: viewModel.segments,
          rotationAngle: viewModel.rotationAngle,
          isSpinning: viewModel.isSpinning
        )
        .scaleEffect(viewModel.isSpinning ? 1.03 : 1.0)
        .animation(.easeInOut(duration: 0.35), value: viewModel.isSpinning)

        AccentPillButton(
          title: viewModel.isSpinning ? "Spinning..." : "Spin!",
          color: AppColor.accent,
          isEnabled: !viewModel.isSpinning,
          action: viewModel.spin
        )
        .scaleEffect(viewModel.isSpinning ? 0.96 : 1.0)
        .animation(.easeInOut(duration: 0.25), value: viewModel.isSpinning)

        if viewModel.showResult, let option = viewModel.selectedOption {
          ResultBanner(
            emoji: option.emoji,
            title: option.text,
            subtitle: "Weight \(option.weight)/5",
            onDismiss: viewModel.dismissResult
          )
          .padding(.horizontal, AppSpacing.lg)
          .transition(.asymmetric(
            insertion: .scale(scale: 0.85).combined(with: .opacity),
            removal: .opacity
          ))
        }

        Spacer()
      }
      .padding(.top, AppSpacing.sm)
      .animation(.spring(response: 0.45, dampingFraction: 0.72), value: viewModel.showResult)
    }
    .appBackToolbar(action: viewModel.goBack)
    .sheet(isPresented: $viewModel.showJournal) {
      if let id = viewModel.pendingHistoryId, let option = viewModel.selectedOption {
        JournalFeedbackSheet(
          isPresented: $viewModel.showJournal,
          title: "\(option.emoji) \(option.text)",
          historyId: id,
          onSubmit: viewModel.submitJournal
        )
      }
    }
  }
}
