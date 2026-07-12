import SwiftUI

// MARK: - Hero

struct HomeHeroWidget: View {
  let greeting: String
  let subtitle: String
  let primaryAction: () -> Void
  let isEnabled: Bool

  var body: some View {
    ZStack(alignment: .bottomLeading) {
      Image("HomeHero")
        .resizable()
        .scaledToFill()
        .frame(height: 200)
        .clipped()

      LinearGradient(
        colors: [.clear, AppColor.background.opacity(0.3), AppColor.background.opacity(0.92)],
        startPoint: .top,
        endPoint: .bottom
      )

      VStack(alignment: .leading, spacing: AppSpacing.sm) {
        Text(greeting)
          .font(.caption.weight(.semibold))
          .foregroundColor(AppColor.accent)
          .textCase(.uppercase)

        Text("Can't decide?")
          .font(.title.weight(.bold))
          .foregroundColor(AppColor.primaryText)

        Text(subtitle)
          .font(.subheadline)
          .foregroundColor(AppColor.secondaryText)
          .lineLimit(2)

        Button(action: primaryAction) {
          HStack(spacing: 8) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text(isEnabled ? "Spin the Wheel" : "Add Options First")
          }
          .font(.subheadline.weight(.bold))
          .foregroundColor(AppColor.primaryText)
          .padding(.horizontal, 18)
          .padding(.vertical, 12)
          .background(
            Capsule()
              .fill(AppGradients.button(AppColor.accent, enabled: isEnabled))
              .overlay(Capsule().fill(AppGradients.cardHighlight))
          )
        }
        .disabled(!isEnabled)
        .padding(.top, 4)
      }
      .padding(AppSpacing.lg)
    }
    .frame(height: 200)
    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
        .stroke(
          LinearGradient(
            colors: [AppColor.accent.opacity(0.6), AppColor.accent.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1.5
        )
    )
    .compositingGroup()
    .shadow(color: AppColor.accent.opacity(0.4), radius: 20, y: 10)
  }
}

// MARK: - Stat widgets

struct HomeStatsGrid: View {
  let options: Int
  let decisions: Int
  let today: Int
  let satisfaction: Int?
  let lists: Int

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
      HomeMiniStatWidget(
        value: "\(options)",
        label: "Options",
        icon: "list.bullet.rectangle.fill",
        tint: AppColor.accent
      )
      HomeMiniStatWidget(
        value: "\(decisions)",
        label: "Total picks",
        icon: "checkmark.seal.fill",
        tint: Color(hex: "6BCB77")
      )
      HomeMiniStatWidget(
        value: "\(today)",
        label: "Today",
        icon: "sun.max.fill",
        tint: Color(hex: "FFD93D")
      )
      if let satisfaction {
        HomeMiniStatWidget(
          value: "\(satisfaction)%",
          label: "Happy rate",
          icon: "hand.thumbsup.fill",
          tint: Color(hex: "FF6B6B")
        )
      } else {
        HomeMiniStatWidget(
          value: "\(lists)",
          label: "Lists",
          icon: "folder.fill",
          tint: Color(hex: "A29BFE")
        )
      }
    }
  }
}

struct HomeMiniStatWidget: View {
  let value: String
  let label: String
  let icon: String
  let tint: Color

  var body: some View {
    HStack(spacing: AppSpacing.md) {
      ZStack {
        RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
          .fill(AppGradients.tinted(tint))
          .frame(width: 42, height: 42)
        Image(systemName: icon)
          .font(.body.weight(.semibold))
          .foregroundColor(tint)
      }

      VStack(alignment: .leading, spacing: 2) {
        Text(value)
          .font(.title3.weight(.bold))
          .foregroundColor(AppColor.primaryText)
          .minimumScaleFactor(0.8)
          .lineLimit(1)
        Text(label)
          .font(.caption2)
          .foregroundColor(AppColor.secondaryText)
      }
      Spacer(minLength: 0)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised, border: tint.opacity(0.35), tint: tint)
  }
}

// MARK: - Activity widget

struct HomeActivityWidget: View {
  let data: [Int]
  let favoriteMode: String

  private var maxValue: Int { max(data.max() ?? 1, 1) }

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.md) {
      HStack {
        VStack(alignment: .leading, spacing: 2) {
          Text("Weekly Activity")
            .font(.subheadline.weight(.semibold))
            .foregroundColor(AppColor.primaryText)
          Text("Favorite mode: \(favoriteMode)")
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
        }
        Spacer()
        Image(systemName: "chart.line.uptrend.xyaxis")
          .foregroundColor(AppColor.accent)
      }

      HStack(alignment: .bottom, spacing: 6) {
        ForEach(Array(data.enumerated()), id: \.offset) { index, count in
          VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
              .fill(
                LinearGradient(
                  colors: [AppColor.accent, AppColor.accent.opacity(0.4)],
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
              .frame(height: max(8, CGFloat(count) / CGFloat(maxValue) * 56))
            Text(dayLabel(offset: data.count - 1 - index))
              .font(.system(size: 9, weight: .medium))
              .foregroundColor(AppColor.secondaryText)
          }
          .frame(maxWidth: .infinity)
        }
      }
      .frame(height: 72, alignment: .bottom)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .floating, tint: AppColor.accent)
  }

  private func dayLabel(offset: Int) -> String {
    let calendar = Calendar.current
    guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { return "" }
    return DateFormatter.shortDay.string(from: date)
  }
}

// MARK: - Mode widgets with images

struct HomeFeaturedModesRow: View {
  let onWheel: () -> Void
  let onGuided: () -> Void
  let wheelEnabled: Bool
  let guidedEnabled: Bool

  var body: some View {
    HStack(spacing: AppSpacing.sm) {
      HomeImageModeWidget(
        imageName: "WidgetWheel",
        title: "Wheel",
        subtitle: "Weighted spin",
        tint: AppColor.accent,
        isEnabled: wheelEnabled,
        isLarge: true,
        action: onWheel
      )
      HomeImageModeWidget(
        imageName: "WidgetGuided",
        title: "Guided",
        subtitle: "Smart filters",
        tint: Color(hex: "00CEC9"),
        isEnabled: guidedEnabled,
        isLarge: true,
        action: onGuided
      )
    }
  }
}

struct HomeModesGrid: View {
  let onCoin: () -> Void
  let onDice: () -> Void
  let onElimination: () -> Void
  let onBracket: () -> Void
  let diceEnabled: Bool
  let tournamentEnabled: Bool

  private let columns = [GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
      HomeImageModeWidget(
        imageName: "WidgetCoin",
        title: "Coin",
        subtitle: "Heads or tails",
        tint: Color(hex: "FFD93D"),
        isEnabled: true,
        action: onCoin
      )
      HomeImageModeWidget(
        imageName: "WidgetDice",
        title: "Dice",
        subtitle: "Custom roll",
        tint: Color(hex: "6BCB77"),
        isEnabled: diceEnabled,
        action: onDice
      )
      HomeImageModeWidget(
        imageName: "WidgetTournament",
        title: "Elimination",
        subtitle: "Knockout",
        tint: Color(hex: "FF6B6B"),
        isEnabled: tournamentEnabled,
        action: onElimination
      )
      HomeImageModeWidget(
        imageName: "WidgetTournament",
        title: "Bracket",
        subtitle: "Tournament",
        tint: Color(hex: "A29BFE"),
        isEnabled: tournamentEnabled,
        action: onBracket
      )
    }
  }
}

struct HomeImageModeWidget: View {
  let imageName: String
  let title: String
  let subtitle: String
  let tint: Color
  var isEnabled: Bool = true
  var isLarge: Bool = false
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ZStack(alignment: .bottomLeading) {
        Image(imageName)
          .resizable()
          .scaledToFill()
          .frame(height: isLarge ? 130 : 110)
          .clipped()
          .opacity(isEnabled ? 1 : 0.35)

        LinearGradient(
          colors: [.clear, AppColor.background.opacity(0.85)],
          startPoint: .top,
          endPoint: .bottom
        )

        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(isLarge ? .headline.weight(.bold) : .subheadline.weight(.bold))
            .foregroundColor(AppColor.primaryText)
          Text(subtitle)
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
        }
        .padding(AppSpacing.md)
      }
      .frame(maxWidth: .infinity)
      .frame(height: isLarge ? 130 : 110)
      .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
          .stroke(
            LinearGradient(
              colors: [tint.opacity(isEnabled ? 0.7 : 0.2), tint.opacity(0.1)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1.5
          )
      )
      .compositingGroup()
      .shadow(color: isEnabled ? tint.opacity(0.35) : .clear, radius: 10, y: 5)
    }
    .disabled(!isEnabled)
  }
}

// MARK: - Shortcut widgets

struct HomeShortcutsRow: View {
  let onTemplates: () -> Void
  let onCollections: () -> Void
  let onAdd: () -> Void
  let onStats: () -> Void
  let onHistory: () -> Void

  var body: some View {
    VStack(spacing: AppSpacing.sm) {
      HStack(spacing: AppSpacing.sm) {
        HomeShortcutWidget(
          imageName: "WidgetWheel",
          title: "Templates",
          subtitle: "Quick-start lists",
          icon: "sparkles",
          tint: AppColor.accent,
          action: onTemplates
        )
        HomeShortcutWidget(
          imageName: "WidgetGuided",
          title: "Collections",
          subtitle: "Organize options",
          icon: "folder.fill",
          tint: Color(hex: "A29BFE"),
          action: onCollections
        )
      }

      HStack(spacing: AppSpacing.sm) {
        HomeShortcutPill(
          icon: "plus.circle.fill",
          title: "Add",
          tint: AppColor.accent,
          action: onAdd
        )
        HomeShortcutPill(
          icon: "chart.bar.fill",
          title: "Stats",
          tint: Color(hex: "FFD93D"),
          action: onStats
        )
        HomeShortcutPill(
          icon: "clock.arrow.circlepath",
          title: "History",
          tint: Color(hex: "6BCB77"),
          action: onHistory
        )
      }
    }
  }
}

struct HomeShortcutWidget: View {
  let imageName: String
  let title: String
  let subtitle: String
  let icon: String
  let tint: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ZStack(alignment: .bottomLeading) {
        Image(imageName)
          .resizable()
          .scaledToFill()
          .frame(height: 112)
          .clipped()

        LinearGradient(
          colors: [
            AppColor.background.opacity(0.05),
            AppColor.background.opacity(0.55),
            AppColor.background.opacity(0.96)
          ],
          startPoint: .top,
          endPoint: .bottom
        )

        VStack(alignment: .leading, spacing: 6) {
          HStack(spacing: 6) {
            Image(systemName: icon)
              .font(.caption.weight(.bold))
            Text(title)
              .font(.subheadline.weight(.bold))
          }
          .foregroundColor(AppColor.primaryText)

          Text(subtitle)
            .font(.caption2.weight(.medium))
            .foregroundColor(AppColor.primaryText.opacity(0.78))
            .lineLimit(1)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .frame(maxWidth: .infinity)
      .frame(height: 112)
      .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
          .stroke(
            LinearGradient(
              colors: [tint.opacity(0.75), tint.opacity(0.2)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1.5
          )
      )
      .compositingGroup()
      .shadow(color: tint.opacity(0.3), radius: 10, y: 5)
    }
    .buttonStyle(.plain)
  }
}

struct HomeShortcutPill: View {
  let icon: String
  let title: String
  let tint: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        ZStack {
          RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
            .fill(AppGradients.tinted(tint))
            .frame(width: 46, height: 46)
          Image(systemName: icon)
            .font(.body.weight(.semibold))
            .foregroundColor(tint)
        }

        Text(title)
          .font(.caption.weight(.bold))
          .foregroundColor(AppColor.primaryText)
          .lineLimit(1)
          .minimumScaleFactor(0.85)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .appCard(elevation: .raised, border: tint.opacity(0.28))
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Recent widget

struct HomeRecentWidget: View {
  let decisions: [DecisionHistory]
  let onSeeAll: () -> Void

  var body: some View {
    VStack(spacing: AppSpacing.md) {
      SectionHeader(title: "Recent Picks", actionTitle: "See All", action: onSeeAll)
      ForEach(decisions.prefix(3)) { decision in
        RecentDecisionCell(decision: decision)
      }
    }
  }
}

// MARK: - Empty state widget

struct HomeEmptyWidget: View {
  let onTemplates: () -> Void
  let onAdd: () -> Void

  var body: some View {
    VStack(spacing: AppSpacing.lg) {
      Image("WidgetDice")
        .resizable()
        .scaledToFill()
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        .compositingGroup()
        .shadow(color: AppColor.accent.opacity(0.35), radius: 8, y: 3)

      VStack(spacing: AppSpacing.xs) {
        Text("No options yet")
          .font(.headline)
          .foregroundColor(AppColor.primaryText)
        Text("Start with a template or add your first choice")
          .font(.caption)
          .foregroundColor(AppColor.secondaryText)
          .multilineTextAlignment(.center)
      }

      HStack(spacing: AppSpacing.sm) {
        Button(action: onTemplates) {
          Text("Templates")
            .font(.caption.weight(.bold))
            .foregroundColor(AppColor.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule().fill(AppGradients.accentButton))
        }
        Button(action: onAdd) {
          Text("Add Option")
            .font(.caption.weight(.bold))
            .foregroundColor(AppColor.accent)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .appCard(elevation: .flat)
        }
      }
    }
    .padding(AppSpacing.lg)
    .appCard(elevation: .raised)
  }
}

// MARK: - Bottom dock

struct HomeDockBar: View {
  let onOptions: () -> Void
  let onAdd: () -> Void
  let onStats: () -> Void
  let onSettings: () -> Void

  var body: some View {
    HStack(spacing: 0) {
      dockItem(icon: "list.bullet", label: "Options", action: onOptions)
      dockItem(icon: "plus.circle.fill", label: "Add", action: onAdd, accent: true)
      dockItem(icon: "chart.bar.fill", label: "Stats", action: onStats)
      dockItem(icon: "gearshape.fill", label: "Settings", action: onSettings)
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 8)
    .background(
      RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
        .fill(AppGradients.cardSurface)
        .overlay(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous).fill(AppGradients.cardHighlight))
    )
    .overlay(
      RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
        .stroke(AppColor.accent.opacity(0.25), lineWidth: 1)
    )
    .compositingGroup()
    .shadow(color: .black.opacity(0.35), radius: 16, y: 8)
  }

  private func dockItem(icon: String, label: String, action: @escaping () -> Void, accent: Bool = false) -> some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: icon)
          .font(accent ? .title2 : .body)
          .foregroundColor(accent ? AppColor.accent : AppColor.secondaryText)
        Text(label)
          .font(.system(size: 10, weight: .medium))
          .foregroundColor(accent ? AppColor.accent : AppColor.secondaryText)
      }
      .frame(maxWidth: .infinity)
    }
  }
}
