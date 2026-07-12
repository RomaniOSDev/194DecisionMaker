import SwiftUI

struct DiceView: View {
  @StateObject private var viewModel: DiceViewModel

  init(viewModel: DiceViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: AppSpacing.xl) {
        ScreenHeader(emoji: "🎲", title: "Custom Dice", subtitle: "Roll to pick from your options")

        VStack(spacing: AppSpacing.md) {
          Stepper("Sides: \(viewModel.sides)", value: $viewModel.sides, in: 3...12)
            .font(.subheadline.weight(.medium))
            .foregroundColor(AppColor.primaryText)
            .padding(AppSpacing.md)
            .appCard(elevation: .raised, tint: AppColor.accent)
            .padding(.horizontal, AppSpacing.lg)

          ZStack {
            RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
              .fill(AppGradients.tinted(Color(hex: "6BCB77")))
              .frame(width: 150, height: 150)
              .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                  .stroke(
                    LinearGradient(
                      colors: [Color(hex: "6BCB77"), Color(hex: "6BCB77").opacity(0.4)],
                      startPoint: .topLeading,
                      endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                  )
              )
              .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                  .fill(AppGradients.cardHighlight)
              )

            if viewModel.isRolling {
              Text("...")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(AppColor.primaryText)
            } else if let roll = viewModel.rollValue {
              Text("\(roll)")
                .font(.system(size: 56, weight: .black, design: .rounded))
                .foregroundColor(AppColor.primaryText)
            } else {
              Text("🎲").font(.system(size: 56))
            }
          }
          .rotation3DEffect(
            .degrees(viewModel.isRolling ? 360 : 0),
            axis: (x: 1, y: 1, z: 0)
          )
          .animation(viewModel.isRolling ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: viewModel.isRolling)
          .compositingGroup()
          .shadow(color: Color(hex: "6BCB77").opacity(0.4), radius: 16, y: 8)
        }

        AccentPillButton(
          title: viewModel.isRolling ? "Rolling..." : "Roll Dice!",
          color: Color(hex: "6BCB77"),
          isEnabled: viewModel.canRoll,
          action: viewModel.roll
        )

        if viewModel.showResult, let option = viewModel.selectedOption {
          ResultBanner(
            emoji: option.emoji,
            title: option.text,
            subtitle: "Dice roll matched this option"
          )
          .padding(.horizontal, AppSpacing.lg)
        }

        Spacer()
      }
      .padding(.top, AppSpacing.sm)
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
