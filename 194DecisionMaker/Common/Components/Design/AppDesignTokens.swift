import SwiftUI

enum AppSpacing {
  static let xs: CGFloat = 4
  static let sm: CGFloat = 8
  static let md: CGFloat = 16
  static let lg: CGFloat = 24
  static let xl: CGFloat = 32
}

enum AppRadius {
  static let sm: CGFloat = 10
  static let md: CGFloat = 16
  static let lg: CGFloat = 22
}

enum AppGradients {
  static let screenBase = LinearGradient(
    colors: [Color(hex: "0A0E22"), Color(hex: "0F1328"), Color(hex: "151B35")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let cardSurface = LinearGradient(
    colors: [Color(hex: "1C2544").opacity(0.95), Color(hex: "111831").opacity(0.88)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let cardHighlight = LinearGradient(
    colors: [Color.white.opacity(0.14), Color.white.opacity(0.02), Color.clear],
    startPoint: .top,
    endPoint: .center
  )

  static let accentButton = LinearGradient(
    colors: [Color(hex: "0390F8"), Color(hex: "0277DB"), Color(hex: "015EA8")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let sectionTitle = LinearGradient(
    colors: [AppColor.primaryText, AppColor.primaryText.opacity(0.85)],
    startPoint: .leading,
    endPoint: .trailing
  )

  static func tinted(_ color: Color) -> LinearGradient {
    LinearGradient(
      colors: [color.opacity(0.35), color.opacity(0.12)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  static func button(_ color: Color, enabled: Bool) -> LinearGradient {
    enabled
      ? LinearGradient(colors: [color.opacity(0.95), color.opacity(0.75)], startPoint: .top, endPoint: .bottom)
      : LinearGradient(colors: [Color.gray.opacity(0.45), Color.gray.opacity(0.35)], startPoint: .top, endPoint: .bottom)
  }
}

enum AppElevation: Equatable {
  case flat
  case raised
  case floating
  case hero

  var radius: CGFloat {
    switch self {
    case .flat: return 0
    case .raised: return 8
    case .floating: return 14
    case .hero: return 20
    }
  }

  var y: CGFloat {
    switch self {
    case .flat: return 0
    case .raised: return 4
    case .floating: return 8
    case .hero: return 12
    }
  }

  var opacity: Double {
    switch self {
    case .flat: return 0
    case .raised: return 0.22
    case .floating: return 0.32
    case .hero: return 0.42
    }
  }
}

struct AppCardSurface: View {
  var cornerRadius: CGFloat = AppRadius.md
  var border: Color = AppColor.accent.opacity(0.2)
  var tint: Color? = nil

  var body: some View {
    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
      .fill(AppGradients.cardSurface)
      .overlay {
        if let tint {
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(AppGradients.tinted(tint))
        }
      }
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .fill(AppGradients.cardHighlight)
      }
      .overlay {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .stroke(border, lineWidth: 1)
      }
  }
}

extension View {
  func appCard(
    elevation: AppElevation = .raised,
    border: Color = AppColor.accent.opacity(0.2),
    tint: Color? = nil,
    cornerRadius: CGFloat = AppRadius.md
  ) -> some View {
    background(
      AppCardSurface(cornerRadius: cornerRadius, border: border, tint: tint)
    )
    .compositingGroup()
    .shadow(
      color: (tint ?? .black).opacity(elevation.opacity),
      radius: elevation.radius,
      x: 0,
      y: elevation.y
    )
  }

  /// Single accent shadow — use sparingly (max 1 per screen region).
  func appAccentGlow(_ color: Color, elevation: AppElevation = .floating) -> some View {
    shadow(color: color.opacity(elevation.opacity + 0.1), radius: elevation.radius, x: 0, y: elevation.y)
  }

  @available(*, deprecated, message: "Use appCard(elevation:) or appAccentGlow")
  func appGlow(color: Color, radius: CGFloat = 12) -> some View {
    shadow(color: color.opacity(0.35), radius: radius, x: 0, y: 4)
  }
}
