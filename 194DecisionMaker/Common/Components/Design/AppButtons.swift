import SwiftUI

struct PrimaryButton: View {
  let title: String
  var icon: String? = nil
  var color: Color = AppColor.accent
  var isEnabled: Bool = true
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        if let icon { Image(systemName: icon) }
        Text(title).fontWeight(.semibold)
      }
      .font(.headline)
      .foregroundColor(AppColor.primaryText)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(
        RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
          .fill(AppGradients.button(color, enabled: isEnabled))
          .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
              .fill(AppGradients.cardHighlight)
          )
      )
      .compositingGroup()
      .shadow(
        color: isEnabled ? color.opacity(0.4) : .clear,
        radius: 10,
        y: 5
      )
    }
    .disabled(!isEnabled)
  }
}

struct AccentPillButton: View {
  let title: String
  var color: Color = AppColor.accent
  var isEnabled: Bool = true
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.headline.weight(.semibold))
        .foregroundColor(AppColor.primaryText)
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(
          Capsule()
            .fill(AppGradients.button(color, enabled: isEnabled))
            .overlay(Capsule().fill(AppGradients.cardHighlight))
        )
        .compositingGroup()
        .shadow(color: isEnabled ? color.opacity(0.45) : .clear, radius: 12, y: 6)
    }
    .disabled(!isEnabled)
  }
}

struct IconTileButton: View {
  let icon: String
  let label: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: AppSpacing.xs) {
        Image(systemName: icon).font(.title3)
        Text(label).font(.caption2.weight(.medium))
      }
      .foregroundColor(AppColor.primaryText)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .appCard(elevation: .raised)
    }
  }
}

struct QuickLinkCell: View {
  let icon: String
  let title: String
  let subtitle: String
  let tint: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: AppSpacing.md) {
        ZStack {
          RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
            .fill(AppGradients.tinted(tint))
            .frame(width: 44, height: 44)
          Image(systemName: icon).foregroundColor(tint)
        }
        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(AppColor.primaryText)
          Text(subtitle)
            .font(.caption2)
            .foregroundColor(AppColor.secondaryText)
        }
        Spacer()
        Image(systemName: "chevron.right")
          .font(.caption.weight(.semibold))
          .foregroundColor(AppColor.secondaryText)
      }
      .padding(AppSpacing.md)
      .appCard(elevation: .raised, border: tint.opacity(0.35), tint: tint)
    }
  }
}

struct FilterChipCell: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .foregroundColor(isSelected ? AppColor.primaryText : AppColor.secondaryText)
        .background {
          if isSelected {
            Capsule().fill(AppGradients.accentButton)
          } else {
            Capsule().fill(AppGradients.cardSurface)
          }
        }
        .overlay(Capsule().stroke(isSelected ? Color.clear : AppColor.accent.opacity(0.25), lineWidth: 1))
        .compositingGroup()
        .shadow(color: isSelected ? AppColor.accent.opacity(0.35) : .clear, radius: 8, y: 3)
    }
  }
}
