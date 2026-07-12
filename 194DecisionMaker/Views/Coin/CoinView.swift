import SwiftUI

struct CoinView: View {
  @StateObject private var viewModel: CoinViewModel

  init(viewModel: CoinViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: AppSpacing.xl) {
        ScreenHeader(emoji: "🪙", title: "Coin Flip", subtitle: "Heads or tails — instant answer")

        Coin3DView(
          isFlipping: viewModel.isFlipping,
          result: viewModel.result,
          rotation: viewModel.rotation
        )
        .frame(width: 170, height: 170)

        AccentPillButton(
          title: viewModel.isFlipping ? "Flipping..." : "Flip!",
          color: Color(hex: "FFD93D"),
          isEnabled: !viewModel.isFlipping,
          action: viewModel.flip
        )

        if viewModel.showResult, let result = viewModel.result {
          ResultBanner(
            emoji: "🪙",
            title: result.rawValue,
            subtitle: "The coin has spoken",
            accent: Color(hex: "FFD93D"),
            onDismiss: viewModel.dismissResult
          )
          .padding(.horizontal, AppSpacing.lg)
        }

        Spacer()
      }
      .padding(.top, AppSpacing.sm)
    }
    .appBackToolbar(action: viewModel.goBack)
  }
}

struct Coin3DView: View {
  let isFlipping: Bool
  let result: CoinSide?
  let rotation: Double

  var body: some View {
    ZStack {
      Circle()
        .fill(
          RadialGradient(
            colors: [Color(hex: "FFE566"), Color(hex: "FFA500"), Color(hex: "CC8400")],
            center: .init(x: 0.35, y: 0.3),
            startRadius: 10,
            endRadius: 90
          )
        )
        .frame(width: 170, height: 170)
        .overlay(Circle().stroke(Color(hex: "FFD93D").opacity(0.6), lineWidth: 4))
        .rotation3DEffect(.degrees(isFlipping ? rotation : 0), axis: (x: 1, y: 0, z: 0))

      if let result, !isFlipping {
        Text(result == .heads ? "H" : "T")
          .font(.system(size: 56, weight: .black, design: .rounded))
          .foregroundColor(Color(hex: "8B6914").opacity(0.5))
      } else if !isFlipping {
        Text("🪙").font(.system(size: 64))
      }
    }
    .compositingGroup()
    .shadow(color: Color(hex: "FFD93D").opacity(0.45), radius: 20, y: 10)
  }
}
