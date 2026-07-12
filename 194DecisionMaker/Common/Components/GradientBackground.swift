import SwiftUI

/// Static, GPU-friendly background — no blur, no animation.
struct GradientBackground: View {
  var body: some View {
    ZStack {
      Color(hex: "0A0E22")

      AppGradients.screenBase

      RadialGradient(
        colors: [AppColor.accent.opacity(0.18), .clear],
        center: .init(x: 0.15, y: 0.1),
        startRadius: 20,
        endRadius: 260
      )

      RadialGradient(
        colors: [Color(hex: "6C5CE7").opacity(0.14), .clear],
        center: .init(x: 0.9, y: 0.75),
        startRadius: 10,
        endRadius: 220
      )

      RadialGradient(
        colors: [Color(hex: "00CEC9").opacity(0.08), .clear],
        center: .init(x: 0.5, y: 1.0),
        startRadius: 0,
        endRadius: 300
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
  }
}
