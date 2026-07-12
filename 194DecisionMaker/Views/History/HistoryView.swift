import SwiftUI

struct HistoryView: View {
  @StateObject private var viewModel: HistoryViewModel
  @State private var showClearAlert = false

  init(viewModel: HistoryViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: AppSpacing.md) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: AppSpacing.sm) {
            FilterChipCell(title: "All", isSelected: viewModel.filterMode == nil) {
              viewModel.filterMode = nil
            }
            ForEach(DecisionMode.allCases, id: \.self) { mode in
              FilterChipCell(
                title: "\(mode.icon) \(mode.rawValue)",
                isSelected: viewModel.filterMode == mode
              ) {
                viewModel.filterMode = mode
              }
            }
          }
        }

        ToggleSettingRow(title: "Favorites only", isOn: $viewModel.showFavoritesOnly)

        ScrollView {
          LazyVStack(spacing: AppSpacing.sm) {
            ForEach(viewModel.filteredHistory) { item in
              HistoryCell(
                item: item,
                onFavorite: { viewModel.toggleFavorite(item) },
                onDelete: { viewModel.deleteHistory(item) }
              )
            }
          }
          .padding(.vertical, AppSpacing.xs)
        }
        .clearScrollBackground()
        .overlay {
          if viewModel.filteredHistory.isEmpty {
            EmptyStateView(
              icon: "📋",
              title: "No history yet",
              message: "Your decisions will appear here with journal notes",
              buttonTitle: "",
              action: {}
            )
          }
        }
      }
      .padding(.horizontal, AppSpacing.lg)
      .padding(.top, AppSpacing.sm)
    }
    .appBackToolbar(action: viewModel.goBack)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text("History")
          .font(.headline)
          .foregroundColor(AppColor.primaryText)
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button { showClearAlert = true } label: {
          Text("Clear")
            .font(.caption.weight(.semibold))
            .foregroundColor(.red.opacity(0.85))
        }
      }
    }
    .alert("Clear history?", isPresented: $showClearAlert) {
      Button("Clear", role: .destructive, action: viewModel.clearHistory)
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("All history entries will be permanently deleted.")
    }
    .onAppear { viewModel.loadHistory() }
  }
}
