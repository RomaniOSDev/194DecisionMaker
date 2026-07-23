import SwiftUI

struct NoInternetView: View {
    var onRetry: () -> Void

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 18) {
                Spacer(minLength: 0)

                Image(systemName: "wifi.slash")
                    .font(.system(size: 52, weight: .semibold))
                    .foregroundColor(AppColor.accent)

                Text("No Internet Connection")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(AppColor.primaryText)
                    .multilineTextAlignment(.center)

                Text("Please check your connection and try again.")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(AppColor.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Spacer(minLength: 0)

                VStack(spacing: 12) {
                    Button(action: onRetry) {
                        Text("Retry")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppColor.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppGradients.accentButton)
                            .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 26)
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    NoInternetView(onRetry: {})
}
