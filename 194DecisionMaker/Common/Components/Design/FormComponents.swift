import SwiftUI

struct AppSearchField: View {
  @Binding var text: String
  let placeholder: String

  var body: some View {
    HStack(spacing: AppSpacing.sm) {
      Image(systemName: "magnifyingglass")
        .foregroundColor(AppColor.accent)
      TextField(placeholder, text: $text)
        .textFieldStyle(.plain)
        .foregroundColor(AppColor.primaryText)
      if !text.isEmpty {
        Button { text = "" } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(AppColor.secondaryText)
        }
      }
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised, tint: AppColor.accent)
  }
}

struct FormFieldSection<Content: View>: View {
  let title: String
  @ViewBuilder let content: Content

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.sm) {
      Text(title)
        .font(.caption.weight(.bold))
        .foregroundColor(AppColor.secondaryText)
        .textCase(.uppercase)
      content
    }
  }
}

struct AppTextField: View {
  let placeholder: String
  @Binding var text: String

  var body: some View {
    TextField(placeholder, text: $text)
      .textFieldStyle(.plain)
      .padding(AppSpacing.md)
      .foregroundColor(AppColor.primaryText)
      .appCard(elevation: .flat)
  }
}

struct EmojiPickerCell: View {
  let emojis: [String]
  @Binding var selected: String

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppSpacing.sm) {
        ForEach(emojis, id: \.self) { emoji in
          Button { selected = emoji } label: {
            Text(emoji)
              .font(.title2)
              .frame(width: 44, height: 44)
              .background(
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                  .fill(selected == emoji ? AppGradients.tinted(AppColor.accent) : AppGradients.cardSurface)
              )
              .overlay(
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                  .stroke(selected == emoji ? AppColor.accent : AppColor.accent.opacity(0.15), lineWidth: selected == emoji ? 2 : 1)
              )
          }
        }
      }
    }
  }
}

struct ColorPickerCell: View {
  let colors: [String]
  @Binding var selected: String

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: AppSpacing.md) {
        ForEach(colors, id: \.self) { hex in
          let isSelected = selected == hex
          Button { selected = hex } label: {
            Circle()
              .fill(Color(hex: hex))
              .frame(width: 38, height: 38)
              .overlay(Circle().stroke(isSelected ? AppColor.primaryText : Color.clear, lineWidth: 2.5))
              .compositingGroup()
              .shadow(color: isSelected ? Color(hex: hex).opacity(0.5) : .clear, radius: 6, y: 2)
          }
        }
      }
    }
  }
}

struct ResultBanner: View {
  let emoji: String
  let title: String
  let subtitle: String?
  var accent: Color = AppColor.accent
  var onDismiss: (() -> Void)? = nil

  var body: some View {
    VStack(spacing: AppSpacing.sm) {
      Text("🎉 Result")
        .font(.caption.weight(.bold))
        .foregroundColor(accent)
      HStack(spacing: AppSpacing.md) {
        Text(emoji).font(.largeTitle)
        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.title3.weight(.bold))
            .foregroundColor(AppColor.primaryText)
          if let subtitle {
            Text(subtitle)
              .font(.caption)
              .foregroundColor(AppColor.secondaryText)
          }
        }
      }
      if let onDismiss {
        Button("Dismiss", action: onDismiss)
          .font(.subheadline.weight(.medium))
          .foregroundColor(accent)
      }
    }
    .padding(AppSpacing.lg)
    .frame(maxWidth: .infinity)
    .appCard(elevation: .hero, border: accent.opacity(0.55), tint: accent)
  }
}

struct ToggleSettingRow: View {
  let title: String
  @Binding var isOn: Bool

  var body: some View {
    Toggle(title, isOn: $isOn)
      .font(.subheadline)
      .foregroundColor(AppColor.primaryText)
      .tint(AppColor.accent)
      .padding(AppSpacing.md)
      .appCard(elevation: .raised)
  }
}

struct StepperSettingRow: View {
  let title: String
  @Binding var value: Int
  let range: ClosedRange<Int>
  var step: Int = 1

  var body: some View {
    Stepper(title, value: $value, in: range, step: step)
      .font(.subheadline)
      .foregroundColor(AppColor.primaryText)
      .padding(AppSpacing.md)
      .appCard(elevation: .raised)
  }
}
