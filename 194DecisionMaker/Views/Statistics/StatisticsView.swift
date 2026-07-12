import SwiftUI

struct StatisticsView: View {
  @StateObject private var viewModel: StatisticsViewModel

  init(viewModel: StatisticsViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(emoji: "📊", title: "Statistics", subtitle: "Track your decision patterns")

          HStack(spacing: AppSpacing.sm) {
            StatBlockCell(value: "\(viewModel.totalDecisions)", label: "Total", color: AppColor.accent)
            StatBlockCell(value: "\(viewModel.wheelDecisions)", label: "Wheel", color: Color(hex: "FFD93D"))
            StatBlockCell(value: "\(viewModel.diceDecisions)", label: "Dice", color: Color(hex: "6BCB77"))
          }

          HStack(spacing: AppSpacing.sm) {
            StatBlockCell(value: "\(viewModel.eliminationDecisions)", label: "Elimination", color: Color(hex: "FF6B6B"), compact: true)
            StatBlockCell(value: "\(viewModel.bracketDecisions)", label: "Bracket", color: Color(hex: "A29BFE"), compact: true)
            StatBlockCell(value: "\(viewModel.guidedDecisions)", label: "Guided", color: Color(hex: "00CEC9"), compact: true)
          }

          if !viewModel.categoryStats.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
              SectionHeader(title: "Decision Journal")
              ForEach(viewModel.categoryStats, id: \.0) { category, stats in
                journalCell(category: category, stats: stats)
              }
            }
          }

          VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Weekly Activity")
            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
              ForEach(viewModel.dailyData, id: \.0) { day, count in
                VStack(spacing: 4) {
                  Text("\(count)")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(AppColor.secondaryText)
                  RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(
                      LinearGradient(
                        colors: [AppColor.accent, AppColor.accent.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                      )
                    )
                    .frame(width: 30, height: max(CGFloat(count) * 18 + 8, 8))
                  Text(day)
                    .font(.caption2)
                    .foregroundColor(AppColor.secondaryText)
                }
                .frame(maxWidth: .infinity)
              }
            }
            .padding(AppSpacing.md)
            .appCard(elevation: .raised, tint: AppColor.accent)
          }

          if !viewModel.topOptions.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
              SectionHeader(title: "Top Options")
              ForEach(Array(viewModel.topOptions.enumerated()), id: \.offset) { index, item in
                topOptionCell(rank: index + 1, name: item.0, count: item.1)
              }
            }
          }

          if let favorite = viewModel.favoriteOption {
            ResultBanner(emoji: "⭐", title: favorite, subtitle: "Most picked option", accent: Color(hex: "FF6B6B"))
          }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .onAppear { viewModel.loadStats() }
  }

  private func journalCell(category: String, stats: CategorySatisfaction) -> some View {
    HStack {
      Text(category)
        .font(.subheadline.weight(.medium))
        .foregroundColor(AppColor.primaryText)
      Spacer()
      Text("\(stats.satisfactionPercent)%")
        .font(.headline.weight(.bold))
        .foregroundColor(AppColor.accent)
      Text("happy")
        .font(.caption2)
        .foregroundColor(AppColor.secondaryText)
      TagBadge(text: "\(stats.total)", color: AppColor.secondaryText)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }

  private func topOptionCell(rank: Int, name: String, count: Int) -> some View {
    HStack(spacing: AppSpacing.md) {
      Text("#\(rank)")
        .font(.caption.weight(.black))
        .foregroundColor(AppColor.accent)
        .frame(width: 28)
      Text(name)
        .font(.subheadline)
        .foregroundColor(AppColor.primaryText)
        .lineLimit(1)
      Spacer()
      TagBadge(text: "\(count)x", color: AppColor.secondaryText)
    }
    .padding(AppSpacing.md)
    .appCard(elevation: .raised)
  }
}
