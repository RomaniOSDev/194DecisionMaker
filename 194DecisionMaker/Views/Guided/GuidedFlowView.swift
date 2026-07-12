import SwiftUI

struct GuidedFlowView: View {
  @StateObject private var viewModel: GuidedFlowViewModel

  init(viewModel: GuidedFlowViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(
            emoji: "🧭",
            title: "Guided Decision",
            subtitle: "Filter options by your situation, then spin"
          )

          guidedSection(title: "How much time?", icon: "clock.fill") {
            Picker("Time", selection: $viewModel.maxMinutes) {
              ForEach(viewModel.minuteOptions, id: \.self) { m in
                Text(m < 60 ? "\(m) min" : "\(m / 60)h").tag(m)
              }
            }
            .pickerStyle(.segmented)
          }

          guidedSection(title: "Budget level", icon: "dollarsign.circle.fill") {
            Picker("Budget", selection: $viewModel.budgetLevel) {
              ForEach(viewModel.budgetOptions, id: \.0) { level, label in
                Text(label).tag(level)
              }
            }
            .pickerStyle(.segmented)
          }

          guidedSection(title: "Location", icon: "location.fill") {
            Picker("Location", selection: $viewModel.indoorPreference) {
              ForEach(GuidedFlowCriteria.IndoorPreference.allCases, id: \.self) { pref in
                Text(pref.rawValue).tag(pref)
              }
            }
            .pickerStyle(.segmented)
          }

          HStack(spacing: AppSpacing.md) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
              .font(.title2)
              .foregroundColor(AppColor.accent)
            VStack(alignment: .leading, spacing: 2) {
              Text("\(viewModel.filteredCount) options match")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(AppColor.primaryText)
              Text("Smart rules also applied")
                .font(.caption2)
                .foregroundColor(AppColor.secondaryText)
            }
            Spacer()
          }
          .padding(AppSpacing.md)
          .appCard(elevation: .raised, border: AppColor.accent.opacity(0.35), tint: AppColor.accent)

          PrimaryButton(
            title: "Spin Filtered Wheel",
            icon: "arrow.right.circle.fill",
            isEnabled: viewModel.filteredCount > 0,
            action: viewModel.startWheel
          )
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .onChange(of: viewModel.maxMinutes) { _, _ in viewModel.updatePreview() }
    .onChange(of: viewModel.budgetLevel) { _, _ in viewModel.updatePreview() }
    .onChange(of: viewModel.indoorPreference) { _, _ in viewModel.updatePreview() }
  }

  private func guidedSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: AppSpacing.sm) {
      HStack(spacing: 6) {
        Image(systemName: icon)
          .foregroundColor(AppColor.accent)
        Text(title)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(AppColor.primaryText)
      }
      content()
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}
