import SwiftUI

struct HomeView: View {
  @StateObject private var viewModel: HomeViewModel
  @ObservedObject private var coordinator: AppCoordinator

  init(viewModel: HomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _coordinator = ObservedObject(wrappedValue: viewModel.coordinator)
  }

  var body: some View {
    NavigationStack(path: $coordinator.path) {
      AppScreenShell {
        ScrollView(showsIndicators: false) {
          VStack(spacing: AppSpacing.xl) {
            HomeHeroWidget(
              greeting: viewModel.greeting,
              subtitle: "Spin, flip, or filter — your next choice is one tap away",
              primaryAction: viewModel.startWheel,
              isEnabled: viewModel.canSpin
            )

            HomeStatsGrid(
              options: viewModel.totalOptions,
              decisions: viewModel.totalDecisions,
              today: viewModel.todayDecisions,
              satisfaction: viewModel.overallSatisfaction,
              lists: viewModel.collections.count
            )

            if viewModel.totalDecisions > 0 {
              HomeActivityWidget(
                data: viewModel.weeklySparkline,
                favoriteMode: viewModel.favoriteModeLabel
              )
            }

            VStack(alignment: .leading, spacing: AppSpacing.md) {
              SectionHeader(title: "Pick a Mode")
              HomeFeaturedModesRow(
                onWheel: viewModel.startWheel,
                onGuided: viewModel.startGuided,
                wheelEnabled: viewModel.hasOptions,
                guidedEnabled: viewModel.hasOptions
              )
              HomeModesGrid(
                onCoin: viewModel.startCoin,
                onDice: viewModel.startDice,
                onElimination: viewModel.startElimination,
                onBracket: viewModel.startBracket,
                diceEnabled: viewModel.hasOptions,
                tournamentEnabled: viewModel.options.count >= 2
              )
            }

            VStack(alignment: .leading, spacing: AppSpacing.md) {
              SectionHeader(title: "Explore")
              HomeShortcutsRow(
                onTemplates: viewModel.goToTemplates,
                onCollections: viewModel.goToCollections,
                onAdd: viewModel.goToOptionForm,
                onStats: viewModel.goToStatistics,
                onHistory: viewModel.goToHistory
              )
            }

            if !viewModel.hasOptions {
              HomeEmptyWidget(
                onTemplates: viewModel.goToTemplates,
                onAdd: viewModel.goToOptionForm
              )
            }

            if !viewModel.recentDecisions.isEmpty {
              HomeRecentWidget(
                decisions: viewModel.recentDecisions,
                onSeeAll: viewModel.goToHistory
              )
            }

            HomeDockBar(
              onOptions: viewModel.goToOptionList,
              onAdd: viewModel.goToOptionForm,
              onStats: viewModel.goToStatistics,
              onSettings: viewModel.goToSettings
            )
            .padding(.top, AppSpacing.sm)

            Spacer(minLength: 16)
          }
          .padding(.horizontal, AppSpacing.lg)
          .padding(.top, AppSpacing.sm)
          .padding(.bottom, AppSpacing.lg)
        }
        .clearScrollBackground()
      }
      .navigationDestination(for: AppDestination.self) { destination in
        coordinator.destination(for: destination)
      }
    }
    .toolbarBackground(.hidden, for: .navigationBar)
    .background(Color.clear)
    .onAppear { viewModel.loadData() }
  }
}
