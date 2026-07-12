import SwiftUI

struct CollectionsView: View {
  @StateObject private var viewModel: CollectionsViewModel
  @State private var showCreate = false
  @State private var newName = ""

  init(viewModel: CollectionsViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(emoji: "📁", title: "Collections", subtitle: "Organize options by category")

          if viewModel.collections.isEmpty {
            EmptyStateView(
              icon: "📁",
              title: "No collections",
              message: "Create a list or apply a template to get started",
              buttonTitle: "Create List",
              action: { showCreate = true }
            )
          } else {
            ForEach(CollectionCategory.allCases, id: \.self) { category in
              let items = viewModel.collections(for: category)
              if !items.isEmpty {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                  SectionHeader(title: "\(category.icon) \(category.rawValue)")
                  ForEach(items) { collection in
                    CollectionCell(
                      collection: collection,
                      optionCount: viewModel.optionCount(for: collection),
                      onTap: { viewModel.openCollection(collection) },
                      onDelete: { viewModel.deleteCollection(collection) }
                    )
                  }
                }
              }
            }
          }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button { showCreate = true } label: {
          Image(systemName: "plus.circle.fill")
            .font(.title3)
            .foregroundColor(AppColor.accent)
        }
      }
    }
    .alert("New Collection", isPresented: $showCreate) {
      TextField("List name", text: $newName)
      Button("Create") {
        guard !newName.isEmpty else { return }
        viewModel.createCollection(name: newName, emoji: "📁", category: .custom)
        newName = ""
      }
      Button("Cancel", role: .cancel) {}
    }
    .onAppear { viewModel.load() }
  }
}
