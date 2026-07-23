import SwiftUI

struct NotificationPermissionView: View {
    var onAccept: () -> Void
    var onDecline: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height >= geometry.size.width
            ZStack {
                GradientBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if isPortrait {
                            Spacer(minLength: geometry.size.height * 0.34)
                        } else {
                            Spacer(minLength: 20)
                        }
                        iconSection
                        Spacer(minLength: 22)
                        textSection
                        Spacer(minLength: 28)
                        buttonsSection
                        Spacer(minLength: isPortrait ? 20 : 24)
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
    }

    private var iconSection: some View {
        Image(systemName: "bell.badge.fill")
            .font(.system(size: 56))
            .foregroundStyle(
                LinearGradient(
                    colors: [AppColor.accent, Color(hex: "6C5CE7")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    private var textSection: some View {
        VStack(spacing: 12) {
            Text("Enable Notifications")
                .font(.system(size: 22, weight: .semibold, design: .default))
                .foregroundColor(AppColor.primaryText)
                .multilineTextAlignment(.center)
            Text("Stay updated with important news and offers. You can change this later in Settings.")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(AppColor.secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    private var buttonsSection: some View {
        VStack(spacing: 14) {
            Button(action: onAccept) {
                Text("Enable")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(AppColor.primaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppGradients.accentButton)
                    .cornerRadius(14)
            }
            .buttonStyle(.plain)

            Button(action: onDecline) {
                Text("Not Now")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(AppColor.secondaryText)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NotificationPermissionView(onAccept: {}, onDecline: {})
}
