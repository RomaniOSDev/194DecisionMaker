import SwiftUI
import UIKit

struct WheelOfFortuneView: View {
  let segments: [WheelSegment]
  let rotationAngle: Double
  let isSpinning: Bool

  private let wheelSize: CGFloat = 300

  @State private var pointerBounce = false
  @State private var glowPulse = false

  var body: some View {
    ZStack {
      outerGlowRing
      wheelAssembly
      centerHub
      pointer
    }
    .frame(width: wheelSize + 24, height: wheelSize + 40)
    .compositingGroup()
    .shadow(color: AppColor.accent.opacity(glowPulse ? 0.55 : 0.38), radius: glowPulse ? 26 : 18, y: 10)
    .onChange(of: isSpinning) { wasSpinning, spinning in
      if wasSpinning && !spinning {
        triggerLandingEffects()
      } else if spinning {
        glowPulse = true
      }
    }
  }

  // MARK: - Wheel assembly

  private var wheelAssembly: some View {
    ZStack {
      Circle()
        .stroke(
          LinearGradient(
            colors: [Color(hex: "4A5568"), Color(hex: "1A2035"), Color(hex: "4A5568")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 10
        )
        .frame(width: wheelSize + 8, height: wheelSize + 8)

      Circle()
        .stroke(AppColor.accent.opacity(0.35), lineWidth: 2)
        .frame(width: wheelSize + 2, height: wheelSize + 2)

      WheelDiscCanvas(segments: segments)
        .frame(width: wheelSize, height: wheelSize)
        .rotationEffect(.degrees(rotationAngle))

      Circle()
        .stroke(Color.white.opacity(0.12), lineWidth: 1)
        .frame(width: wheelSize - 6, height: wheelSize - 6)
    }
  }

  private var outerGlowRing: some View {
    Circle()
      .stroke(AppColor.accent.opacity(0.15), lineWidth: 1)
      .frame(width: wheelSize + 20, height: wheelSize + 20)
      .scaleEffect(isSpinning ? 1.04 : 1.0)
      .opacity(isSpinning ? 0.9 : 0.5)
      .animation(isSpinning ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: isSpinning)
  }

  private var centerHub: some View {
    ZStack {
      Circle()
        .fill(
          RadialGradient(
            colors: [Color(hex: "2A3558"), Color(hex: "111831")],
            center: .center,
            startRadius: 2,
            endRadius: 24
          )
        )
        .frame(width: 48, height: 48)
        .overlay(Circle().stroke(AppColor.accent.opacity(0.5), lineWidth: 2))

      Circle()
        .fill(
          RadialGradient(
            colors: [AppColor.accent, AppColor.accent.opacity(0.6)],
            center: .init(x: 0.35, y: 0.3),
            startRadius: 1,
            endRadius: 16
          )
        )
        .frame(width: 28, height: 28)
        .overlay(Circle().stroke(Color.white.opacity(0.35), lineWidth: 1))

      Image(systemName: "sparkles")
        .font(.caption.weight(.bold))
        .foregroundColor(.white.opacity(0.9))
        .rotationEffect(.degrees(isSpinning ? 360 : 0))
        .animation(isSpinning ? .linear(duration: 2).repeatForever(autoreverses: false) : .default, value: isSpinning)
    }
  }

  private var pointer: some View {
    Image("WheelPointer")
      .resizable()
      .scaledToFit()
      .frame(width: 44, height: 56)
      .shadow(color: .black.opacity(0.35), radius: 4, y: 3)
      .offset(y: -(wheelSize / 2) - 6)
      .rotationEffect(.degrees(pointerBounce ? -8 : 0))
      .offset(y: pointerBounce ? 4 : 0)
      .animation(.spring(response: 0.25, dampingFraction: 0.35), value: pointerBounce)
      .zIndex(10)
  }

  private func triggerLandingEffects() {
    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    withAnimation(.spring(response: 0.22, dampingFraction: 0.32)) {
      pointerBounce = true
      glowPulse = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
      pointerBounce = false
    }
  }
}

// MARK: - Wheel disc canvas

private struct WheelDiscCanvas: View {
  let segments: [WheelSegment]

  var body: some View {
    Canvas { context, size in
      let center = CGPoint(x: size.width / 2, y: size.height / 2)
      let radius = min(size.width, size.height) / 2 - 4

      for (index, segment) in segments.enumerated() {
        let start = Angle(degrees: segment.startAngle - 90)
        let end = Angle(degrees: segment.endAngle - 90)
        let mid = (segment.startAngle + segment.endAngle) / 2
        let midRad = Angle(degrees: mid - 90).radians

        let path = Path { p in
          p.move(to: center)
          p.addArc(center: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
          p.closeSubpath()
        }

        let edgePoint = CGPoint(
          x: center.x + CGFloat(cos(midRad)) * radius,
          y: center.y + CGFloat(sin(midRad)) * radius
        )

        let shade = index.isMultiple(of: 2) ? 1.0 : 0.82
        context.fill(
          path,
          with: .linearGradient(
            Gradient(colors: [
              segment.color.opacity(0.95 * shade),
              segment.color.opacity(0.55 * shade)
            ]),
            startPoint: center,
            endPoint: edgePoint
          )
        )

        context.stroke(path, with: .color(Color.white.opacity(0.22)), lineWidth: 2)

        let textRadius = radius * 0.64
        let labelPoint = CGPoint(
          x: center.x + CGFloat(cos(midRad)) * textRadius,
          y: center.y + CGFloat(sin(midRad)) * textRadius
        )

        let sliceDegrees = segment.endAngle - segment.startAngle
        let fontSize = min(22, max(12, sliceDegrees * 0.28))
        context.draw(
          Text(segment.option.emoji).font(.system(size: fontSize)),
          at: labelPoint
        )
      }

      let innerRing = Path { p in
        p.addArc(center: center, radius: radius * 0.22, startAngle: .zero, endAngle: .degrees(360), clockwise: false)
      }
      context.stroke(innerRing, with: .color(Color.white.opacity(0.08)), lineWidth: 1)
    }
    .clipShape(Circle())
  }
}
