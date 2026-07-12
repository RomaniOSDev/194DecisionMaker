import SwiftUI

struct OnboardingPage: Identifiable {
  let id: Int
  let imageName: String
  let emoji: String
  let title: String
  let subtitle: String
  let tint: Color
  let features: [OnboardingFeature]
}

struct OnboardingFeature: Identifiable {
  let id = UUID()
  let icon: String
  let text: String
}

extension OnboardingPage {
  static let all: [OnboardingPage] = [
    OnboardingPage(
      id: 0,
      imageName: "WidgetWheel",
      emoji: "🎡",
      title: "Spin & Decide",
      subtitle: "Stop overthinking — let the wheel, coin, or dice pick for you in seconds.",
      tint: AppColor.accent,
      features: [
        OnboardingFeature(icon: "arrow.triangle.2.circlepath", text: "Weighted wheel with fair odds"),
        OnboardingFeature(icon: "circle.fill", text: "Instant coin flip"),
        OnboardingFeature(icon: "die.face.5.fill", text: "Custom dice roll")
      ]
    ),
    OnboardingPage(
      id: 1,
      imageName: "WidgetGuided",
      emoji: "📋",
      title: "Organize Choices",
      subtitle: "Group options into collections, use templates, and filter by time or budget.",
      tint: Color(hex: "A29BFE"),
      features: [
        OnboardingFeature(icon: "folder.fill", text: "Collections for every topic"),
        OnboardingFeature(icon: "sparkles", text: "Ready-made templates"),
        OnboardingFeature(icon: "line.3.horizontal.decrease.circle", text: "Guided smart filters")
      ]
    ),
    OnboardingPage(
      id: 2,
      imageName: "WidgetTournament",
      emoji: "📊",
      title: "Track & Improve",
      subtitle: "Review your picks, rate decisions, and discover what works best for you.",
      tint: Color(hex: "6BCB77"),
      features: [
        OnboardingFeature(icon: "clock.arrow.circlepath", text: "Full decision history"),
        OnboardingFeature(icon: "hand.thumbsup.fill", text: "Journal with satisfaction notes"),
        OnboardingFeature(icon: "chart.bar.fill", text: "Stats and weekly activity")
      ]
    )
  ]
}
