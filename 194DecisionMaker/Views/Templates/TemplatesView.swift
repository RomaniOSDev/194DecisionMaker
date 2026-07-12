import SwiftUI

struct TemplatesView: View {
  @StateObject private var viewModel: TemplatesViewModel

  init(viewModel: TemplatesViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(
            emoji: "📋",
            title: "Templates",
            subtitle: "One tap to add a full option list"
          )

          ForEach(viewModel.templates, id: \.id) { template in
            TemplateCell(template: template) {
              viewModel.apply(template)
            }
          }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.goBack)
    .alert("Template Applied", isPresented: .init(
      get: { viewModel.appliedMessage != nil },
      set: { if !$0 { viewModel.appliedMessage = nil } }
    )) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(viewModel.appliedMessage ?? "")
    }
  }
}
