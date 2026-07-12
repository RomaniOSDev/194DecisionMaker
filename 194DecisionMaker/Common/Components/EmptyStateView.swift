import SwiftUI

struct EmptyStateView: View {
  let icon: String
  let title: String
  let message: String
  let buttonTitle: String
  let action: () -> Void

  var body: some View {
    VStack(spacing: AppSpacing.lg) {
      ZStack {
        Circle()
          .fill(AppGradients.tinted(AppColor.accent))
          .frame(width: 90, height: 90)
        Text(icon)
          .font(.system(size: 44))
      }

      VStack(spacing: AppSpacing.xs) {
        Text(title)
          .font(.headline)
          .foregroundColor(AppColor.primaryText)
        Text(message)
          .font(.subheadline)
          .foregroundColor(AppColor.secondaryText)
          .multilineTextAlignment(.center)
      }

      if !buttonTitle.isEmpty {
        PrimaryButton(title: buttonTitle, icon: "arrow.right.circle.fill", action: action)
          .padding(.horizontal, AppSpacing.xl)
      }
    }
    .padding(AppSpacing.xl)
    .appCard(elevation: .raised, tint: AppColor.accent)
  }
}
