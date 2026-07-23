import SwiftUI

/// Three bouncing dots loading indicator.
struct AnimatedLoadingIndicator: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1/30)) { context in
            let t = context.date.timeIntervalSinceReferenceDate
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColor.accent, Color(hex: "6C5CE7")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 16, height: 16)
                        .scaleEffect(bounceScale(t: t, index: index))
                }
            }
        }
    }

    private func bounceScale(t: TimeInterval, index: Int) -> CGFloat {
        let period: Double = 0.6
        let offset = Double(index) * 0.2
        let x = (t + offset).truncatingRemainder(dividingBy: period) / period
        let y = sin(x * .pi)
        return CGFloat(0.7 + 0.3 * max(0, y))
    }
}

/// Rotating gradient ring.
struct RingLoadingIndicator: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: "1C2544").opacity(0.6), lineWidth: 4)
                .frame(width: 56, height: 56)
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [AppColor.accent, Color(hex: "6C5CE7"), AppColor.accent]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 56, height: 56)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

/// Full-screen loading UI matching app gradient.
struct LoadingView: View {
    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 24) {
                RingLoadingIndicator()
                AnimatedLoadingIndicator()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    LoadingView()
}
