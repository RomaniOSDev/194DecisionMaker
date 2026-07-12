import SwiftUI

// MARK: - Stat

struct StatCell: View {
  let value: String
  let label: String
  let icon: String
  var tint: Color = AppColor.accent

  var body: some View {
    VStack(spacing: AppSpacing.xs) {
      Image(systemName: icon)
        .font(.caption)
        .foregroundColor(tint)
      Text(value)
        .font(.title3.weight(.bold))
        .foregroundColor(AppColor.primaryText)
        .minimumScaleFactor(0.7)
        .lineLimit(1)
      Text(label)
        .font(.caption2)
        .foregroundColor(AppColor.secondaryText)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 14)
    .appCard(elevation: .raised, border: tint.opacity(0.32), tint: tint)
  }
}

struct StatBlockCell: View {
  let value: String
  let label: String
  let color: Color
  var compact: Bool = false

  var body: some View {
    VStack(spacing: 4) {
      Text(value)
        .font(compact ? .headline.weight(.bold) : .title2.weight(.bold))
        .foregroundColor(color)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
      Text(label)
        .font(.caption2)
        .foregroundColor(AppColor.secondaryText)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, compact ? 10 : 14)
    .appCard(elevation: .raised, border: color.opacity(0.3), tint: color)
  }
}

// MARK: - Mode

struct ModeGridCell: View {
  let title: String
  let icon: String
  let color: Color
  let isEnabled: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: AppSpacing.sm) {
        ZStack {
          Circle()
            .fill(color.opacity(isEnabled ? 0.22 : 0.08))
            .frame(width: 52, height: 52)
          Text(icon)
            .font(.system(size: 26))
            .opacity(isEnabled ? 1 : 0.4)
        }
        Text(title)
          .font(.caption.weight(.semibold))
          .foregroundColor(isEnabled ? AppColor.primaryText : AppColor.secondaryText)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .appCard(
        elevation: isEnabled ? .raised : .flat,
        border: isEnabled ? color.opacity(0.45) : Color.gray.opacity(0.2),
        tint: isEnabled ? color : nil
      )
    }
    .disabled(!isEnabled)
  }
}

// MARK: - Option

struct OptionCell: View {
  let option: Option
  let onTap: () -> Void
  let onFavorite: () -> Void
  let onDelete: () -> Void

  var body: some View {
  Button(action: onTap) {
    HStack(spacing: AppSpacing.md) {
      ZStack {
        RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
          .fill(AppGradients.tinted(Color(hex: option.color)))
          .frame(width: 48, height: 48)
        Text(option.emoji)
          .font(.title2)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(option.text)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(AppColor.primaryText)
          .lineLimit(1)

        HStack(spacing: 8) {
          TagBadge(text: "W\(option.weight)", color: AppColor.accent)
          if option.usageCount > 0 {
            TagBadge(text: "\(option.usageCount)x", color: AppColor.secondaryText)
          }
          if option.isFavorite {
            TagBadge(text: "★", color: Color(hex: "FF6B6B"))
          }
        }
      }

      Spacer(minLength: 0)

      HStack(spacing: 4) {
        IconActionButton(
          icon: option.isFavorite ? "heart.fill" : "heart",
          color: option.isFavorite ? Color(hex: "FF6B6B") : AppColor.secondaryText,
          action: onFavorite
        )
        IconActionButton(icon: "trash", color: .red.opacity(0.7), action: onDelete)
      }
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised, border: Color(hex: option.color).opacity(0.4), tint: Color(hex: option.color))
  }
  .buttonStyle(.plain)
  }
}

struct TagBadge: View {
  let text: String
  let color: Color

  var body: some View {
    Text(text)
      .font(.caption2.weight(.bold))
      .foregroundColor(color)
      .padding(.horizontal, 7)
      .padding(.vertical, 3)
      .background(Capsule().fill(AppGradients.tinted(color)))
  }
}

struct IconActionButton: View {
  let icon: String
  let color: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: icon)
        .font(.subheadline)
        .foregroundColor(color)
        .frame(width: 34, height: 34)
        .background(Circle().fill(AppGradients.cardSurface))
    }
    .buttonStyle(.plain)
  }
}

// MARK: - History

struct HistoryCell: View {
  let item: DecisionHistory
  let onFavorite: () -> Void
  let onDelete: () -> Void

  var body: some View {
    HStack(spacing: AppSpacing.md) {
      ZStack {
        Circle()
          .fill(AppColor.accent.opacity(0.15))
          .frame(width: 44, height: 44)
        Text(item.optionEmoji)
          .font(.title3)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(item.optionText)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(AppColor.primaryText)

        HStack(spacing: 6) {
          Text("\(item.mode.icon) \(item.mode.rawValue)")
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
          if let s = item.satisfaction {
            Text(s.emoji).font(.caption2)
          }
        }

        if let note = item.note, !note.isEmpty {
          Text(note)
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
            .lineLimit(2)
        }

        Text(DateFormatter.mediumDateTime.string(from: item.date))
          .font(.caption2)
          .foregroundColor(AppColor.secondaryText.opacity(0.8))
      }

      Spacer(minLength: 0)

      VStack(spacing: 4) {
        IconActionButton(
          icon: item.isFavorite ? "heart.fill" : "heart",
          color: item.isFavorite ? Color(hex: "FF6B6B") : AppColor.secondaryText,
          action: onFavorite
        )
        IconActionButton(icon: "trash", color: .red.opacity(0.6), action: onDelete)
      }
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}

struct RecentDecisionCell: View {
  let decision: DecisionHistory

  var body: some View {
    HStack(spacing: AppSpacing.md) {
      Text(decision.optionEmoji)
        .font(.title2)
        .frame(width: 36)

      VStack(alignment: .leading, spacing: 2) {
        Text(decision.optionText)
          .font(.subheadline.weight(.medium))
          .foregroundColor(AppColor.primaryText)
          .lineLimit(1)
        if let s = decision.satisfaction {
          Text("\(s.emoji) logged in journal")
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
        }
      }

      Spacer()

      VStack(alignment: .trailing, spacing: 2) {
        Text(decision.mode.icon)
        Text(DateFormatter.mediumDate.string(from: decision.date))
          .font(.caption2)
          .foregroundColor(AppColor.secondaryText)
      }
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}

// MARK: - Collection & Template

struct CollectionCell: View {
  let collection: OptionCollection
  let optionCount: Int
  let onTap: () -> Void
  let onDelete: () -> Void

  var body: some View {
    HStack(spacing: AppSpacing.md) {
      Button(action: onTap) {
        HStack(spacing: AppSpacing.md) {
          ZStack {
            RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
              .fill(AppColor.accent.opacity(0.18))
              .frame(width: 48, height: 48)
            Text(collection.emoji)
              .font(.title2)
          }
          VStack(alignment: .leading, spacing: 4) {
            Text(collection.name)
              .font(.subheadline.weight(.semibold))
              .foregroundColor(AppColor.primaryText)
            HStack(spacing: 6) {
              TagBadge(text: collection.category.rawValue, color: AppColor.accent)
              TagBadge(text: "\(optionCount) opts", color: AppColor.secondaryText)
            }
          }
          Spacer()
          Image(systemName: "chevron.right")
            .font(.caption.weight(.semibold))
            .foregroundColor(AppColor.secondaryText)
        }
      }
      .buttonStyle(.plain)

      IconActionButton(icon: "trash", color: .red.opacity(0.65), action: onDelete)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}

struct TemplateCell: View {
  let template: DecisionTemplate
  let onApply: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.md) {
      HStack(alignment: .top, spacing: AppSpacing.md) {
        Text(template.emoji)
          .font(.system(size: 36))
          .frame(width: 48)

        VStack(alignment: .leading, spacing: 4) {
          Text(template.name)
            .font(.headline)
            .foregroundColor(AppColor.primaryText)
          Text(template.description)
            .font(.caption)
            .foregroundColor(AppColor.secondaryText)
            .fixedSize(horizontal: false, vertical: true)
          HStack(spacing: 6) {
            TagBadge(text: template.category.rawValue, color: AppColor.accent)
            TagBadge(text: "\(template.options.count) options", color: AppColor.secondaryText)
          }
        }
      }

      PrimaryButton(title: "Use Template", icon: "plus.circle.fill", action: onApply)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .floating, border: AppColor.accent.opacity(0.35), tint: AppColor.accent)
  }
}

// MARK: - Settings

struct SettingCell: View {
  let icon: String
  let title: String
  let subtitle: String?
  let iconColor: Color
  let action: () -> Void

  init(icon: String, title: String, subtitle: String? = nil, iconColor: Color, action: @escaping () -> Void) {
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.iconColor = iconColor
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppSpacing.md) {
        ZStack {
          RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
            .fill(iconColor.opacity(0.18))
            .frame(width: 40, height: 40)
          Image(systemName: icon)
            .foregroundColor(iconColor)
        }
        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.subheadline.weight(.medium))
            .foregroundColor(AppColor.primaryText)
          if let subtitle {
            Text(subtitle)
              .font(.caption2)
              .foregroundColor(AppColor.secondaryText)
          }
        }
        Spacer()
        Image(systemName: "chevron.right")
          .font(.caption.weight(.semibold))
          .foregroundColor(AppColor.secondaryText)
      }
      .padding(AppSpacing.md)
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Match / Bracket

struct MatchCell: View {
  let match: BracketMatch
  let onPick: (Option) -> Void
  let onRandom: () -> Void

  var body: some View {
    VStack(spacing: AppSpacing.sm) {
      if let a = match.optionA, let b = match.optionB {
        HStack(spacing: AppSpacing.sm) {
          ContestantCell(option: a, isWinner: match.winner?.id == a.id) { onPick(a) }
          Text("VS")
            .font(.caption.weight(.black))
            .foregroundColor(AppColor.secondaryText)
          ContestantCell(option: b, isWinner: match.winner?.id == b.id) { onPick(b) }
        }
        Button("Random Pick", action: onRandom)
          .font(.caption.weight(.semibold))
          .foregroundColor(AppColor.accent)
      }
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}

struct ContestantCell: View {
  let option: Option
  let isWinner: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 6) {
        Text(option.emoji).font(.title)
        Text(option.text)
          .font(.caption.weight(.medium))
          .foregroundColor(AppColor.primaryText)
          .multilineTextAlignment(.center)
          .lineLimit(2)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 10)
      .background(
        RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
          .fill(isWinner ? AppColor.accent.opacity(0.3) : Color(hex: option.color).opacity(0.15))
      )
      .overlay(
        RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
          .stroke(isWinner ? AppColor.accent : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(.plain)
  }
}

struct BracketMatchCell: View {
  let match: BracketMatch
  let isActive: Bool
  let onPick: (Option) -> Void
  let onRandom: () -> Void

  var body: some View {
    VStack(spacing: 6) {
      bracketRow(match.optionA, winner: match.winner, match: match)
      bracketRow(match.optionB, winner: match.winner, match: match)
      if isActive, match.winner == nil, match.optionB != nil {
        Button("🎲 Random", action: onRandom)
          .font(.caption2.weight(.semibold))
          .foregroundColor(AppColor.accent)
      }
    }
    .padding(10)
    .appCard(
      elevation: isActive ? .floating : .raised,
      border: isActive ? AppColor.accent.opacity(0.5) : AppColor.accent.opacity(0.15),
      tint: isActive ? AppColor.accent : nil
    )
  }

  @ViewBuilder
  private func bracketRow(_ option: Option?, winner: Option?, match: BracketMatch) -> some View {
    if let option {
      Button {
        if match.winner == nil { onPick(option) }
      } label: {
        HStack(spacing: 6) {
          Text(option.emoji)
          Text(option.text)
            .font(.caption2)
            .lineLimit(1)
            .foregroundColor(AppColor.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(6)
        .background(
          RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(winner?.id == option.id ? AppColor.accent.opacity(0.28) : Color.clear)
        )
      }
      .disabled(match.winner != nil)
      .buttonStyle(.plain)
    } else {
      Text("—")
        .font(.caption2)
        .foregroundColor(AppColor.secondaryText)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
