import SwiftUI

struct OptionListView: View {
  @StateObject private var viewModel: OptionListViewModel

  init(viewModel: OptionListViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: AppSpacing.md) {
        AppSearchField(text: $viewModel.searchText, placeholder: "Search options...")

        ScrollView {
          LazyVStack(spacing: AppSpacing.sm) {
            ForEach(viewModel.filteredOptions) { option in
              OptionCell(
                option: option,
                onTap: { viewModel.goToOptionForm(option: option) },
                onFavorite: { viewModel.toggleFavorite(option) },
                onDelete: { viewModel.deleteOption(option) }
              )
            }
          }
          .padding(.vertical, AppSpacing.xs)
        }
        .clearScrollBackground()
        .overlay {
          if viewModel.filteredOptions.isEmpty {
            EmptyStateView(
              icon: "📝",
              title: "No options found",
              message: "Try a different search or add a new option",
              buttonTitle: "Add Option",
              action: { viewModel.goToOptionForm() }
            )
          }
        }
      }
      .padding(.horizontal, AppSpacing.lg)
      .padding(.top, AppSpacing.sm)
    }
    .appBackToolbar(action: viewModel.goBack)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { viewModel.goToOptionForm() } label: {
          Image(systemName: "plus.circle.fill")
            .font(.title3)
            .foregroundColor(AppColor.accent)
        }
      }
    }
    .onAppear { viewModel.loadOptions() }
  }
}
