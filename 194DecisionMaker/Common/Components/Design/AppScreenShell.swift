import SwiftUI

struct AppScreenShell<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    ZStack {
      GradientBackground()
      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clear)
  }
}

struct ScreenHeader: View {
  let emoji: String
  let title: String
  var subtitle: String? = nil

  var body: some View {
    VStack(spacing: AppSpacing.sm) {
      ZStack {
        Circle()
          .fill(AppGradients.tinted(AppColor.accent))
          .frame(width: 84, height: 84)
          .appAccentGlow(AppColor.accent, elevation: .raised)

        Circle()
          .fill(
            RadialGradient(
              colors: [AppColor.accent.opacity(0.45), .clear],
              center: .center,
              startRadius: 2,
              endRadius: 38
            )
          )
          .frame(width: 76, height: 76)

        Text(emoji)
          .font(.system(size: 40))
      }

      Text(title)
        .font(.title2.weight(.bold))
        .foregroundStyle(AppGradients.sectionTitle)

      if let subtitle {
        Text(subtitle)
          .font(.subheadline)
          .foregroundColor(AppColor.secondaryText)
          .multilineTextAlignment(.center)
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.top, AppSpacing.md)
  }
}

struct SectionHeader: View {
  let title: String
  var actionTitle: String? = nil
  var action: (() -> Void)? = nil

  var body: some View {
    HStack {
      HStack(spacing: 8) {
        RoundedRectangle(cornerRadius: 2)
          .fill(AppGradients.accentButton)
          .frame(width: 3, height: 16)
        Text(title)
          .font(.headline.weight(.semibold))
          .foregroundColor(AppColor.primaryText)
      }
      Spacer()
      if let actionTitle, let action {
        Button(action: action) {
          Text(actionTitle)
            .font(.caption.weight(.bold))
            .foregroundColor(AppColor.accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(AppColor.accent.opacity(0.15)))
        }
      }
    }
  }
}

struct AppBackToolbar: ViewModifier {
  let action: () -> Void

  func body(content: Content) -> some View {
    content
      .navigationBarBackButtonHidden(true)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: action) {
            HStack(spacing: 6) {
              Image(systemName: "chevron.left")
                .font(.subheadline.weight(.semibold))
              Text("Back")
                .font(.subheadline.weight(.medium))
            }
            .foregroundColor(AppColor.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .appCard(elevation: .raised, border: AppColor.accent.opacity(0.3))
          }
        }
      }
  }
}

extension View {
  func appBackToolbar(action: @escaping () -> Void) -> some View {
    modifier(AppBackToolbar(action: action))
  }
}
