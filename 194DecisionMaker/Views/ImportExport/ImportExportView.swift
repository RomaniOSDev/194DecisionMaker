import SwiftUI
import UniformTypeIdentifiers

struct ImportExportView: View {
  @StateObject private var viewModel: ImportExportViewModel
  @State private var showShare = false
  @State private var showImporter = false

  init(viewModel: ImportExportViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(emoji: "📤", title: "Share & Import", subtitle: "Move lists between devices")

          VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Export Preview")
            Text(viewModel.exportText)
              .font(.caption)
              .foregroundColor(AppColor.secondaryText)
              .padding(AppSpacing.md)
              .frame(maxWidth: .infinity, alignment: .leading)
              .appCard(elevation: .raised)

            HStack(spacing: AppSpacing.sm) {
              PrimaryButton(title: "Share JSON", icon: "square.and.arrow.up", action: { showShare = true })
              Button {
                UIPasteboard.general.string = viewModel.exportText
                viewModel.message = "Copied to clipboard."
                viewModel.isError = false
              } label: {
                Text("Copy")
                  .font(.subheadline.weight(.semibold))
                  .foregroundColor(AppColor.accent)
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 16)
                  .appCard(elevation: .raised)
              }
            }
          }

          VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Import JSON")
            TextField("Paste JSON here...", text: $viewModel.importText, axis: .vertical)
              .lineLimit(4...8)
              .padding(AppSpacing.md)
              .foregroundColor(AppColor.primaryText)
              .appCard(elevation: .raised)

            HStack(spacing: AppSpacing.sm) {
              PrimaryButton(title: "Merge", icon: "arrow.triangle.merge", action: {
                viewModel.importFromPastedJSON(merge: true)
              })
              Button {
                viewModel.importFromPastedJSON(merge: false)
              } label: {
                Text("Replace")
                  .font(.subheadline.weight(.semibold))
                  .foregroundColor(.red.opacity(0.9))
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 16)
                  .appCard(elevation: .raised, border: .red.opacity(0.4), tint: .red)
              }
            }

            PrimaryButton(title: "Import from File", icon: "doc.badge.plus", action: { showImporter = true })
          }

          if let message = viewModel.message {
            Text(message)
              .font(.caption.weight(.medium))
              .foregroundColor(viewModel.isError ? .red : AppColor.accent)
              .padding(AppSpacing.md)
              .frame(maxWidth: .infinity)
              .appCard(
                elevation: .raised,
                border: viewModel.isError ? .red.opacity(0.4) : AppColor.accent.opacity(0.3),
                tint: viewModel.isError ? .red : AppColor.accent
              )
          }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .sheet(isPresented: $showShare) {
      if let data = viewModel.exportData {
        ShareSheet(items: [data])
      }
    }
    .fileImporter(
      isPresented: $showImporter,
      allowedContentTypes: [.json, .plainText],
      allowsMultipleSelection: false
    ) { result in
      if case let .success(urls) = result, let url = urls.first,
         let data = try? Data(contentsOf: url) {
        viewModel.importFromData(data, merge: true)
      }
    }
    .onAppear { viewModel.refreshExportText() }
  }
}
