import SwiftUI

struct SettingsView: View {
  @StateObject private var viewModel: SettingsViewModel
  @State private var showResetAlert = false

  init(viewModel: SettingsViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(emoji: "⚙️", title: "Settings", subtitle: "Rules, data & preferences")

          VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Smart Rules")
            ToggleSettingRow(title: "No repeat in a row", isOn: $viewModel.rules.noRepeatInRow)
            StepperSettingRow(
              title: "Cooldown: \(viewModel.rules.cooldownHours)h",
              value: $viewModel.rules.cooldownHours,
              range: 0...72,
              step: 6
            )
            StepperSettingRow(
              title: "Exclude recent: \(viewModel.rules.excludeRecentCount)",
              value: $viewModel.rules.excludeRecentCount,
              range: 0...10
            )
            PrimaryButton(title: "Save Rules", icon: "checkmark.circle.fill", action: viewModel.saveRules)
          }

          VStack(spacing: 0) {
            SettingCell(
              icon: "square.and.arrow.up.fill",
              title: "Share / Import Lists",
              subtitle: "Export JSON or merge lists",
              iconColor: AppColor.accent,
              action: viewModel.goToImportExport
            )
            Divider().background(AppColor.secondaryText.opacity(0.2)).padding(.leading, 56)
            SettingCell(
              icon: "trash.fill",
              title: "Reset All Data",
              subtitle: "Delete everything permanently",
              iconColor: .red,
              action: { showResetAlert = true }
            )
          }
          .appCard(elevation: .raised)

          VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Legal")
            VStack(spacing: 0) {
              SettingCell(
                icon: "star.fill",
                title: "Rate Us",
                subtitle: "Enjoying the app? Leave a review",
                iconColor: Color(hex: "FFD93D"),
                action: viewModel.rateApp
              )
              Divider().background(AppColor.secondaryText.opacity(0.2)).padding(.leading, 56)
              SettingCell(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                iconColor: Color(hex: "00CEC9"),
                action: viewModel.openPrivacyPolicy
              )
              Divider().background(AppColor.secondaryText.opacity(0.2)).padding(.leading, 56)
              SettingCell(
                icon: "doc.text.fill",
                title: "Terms of Use",
                iconColor: Color(hex: "A29BFE"),
                action: viewModel.openTermsOfUse
              )
            }
            .appCard(elevation: .raised)
          }

          Text("Version 2.0")
            .font(.caption)
            .foregroundColor(AppColor.secondaryText)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .alert("Reset all data?", isPresented: $showResetAlert) {
      Button("Reset", role: .destructive, action: viewModel.resetAllData)
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("All options, collections, and history will be permanently deleted.")
    }
  }
}
