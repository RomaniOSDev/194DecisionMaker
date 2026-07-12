import SwiftUI

struct OnboardingView: View {
  @StateObject private var viewModel: OnboardingViewModel

  init(onComplete: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: OnboardingViewModel(onComplete: onComplete))
  }

  var body: some View {
    AppScreenShell {
      VStack(spacing: 0) {
        headerBar

        TabView(selection: $viewModel.currentPage) {
          ForEach(viewModel.pages) { page in
            OnboardingPageView(page: page)
              .tag(page.id)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

        footer
      }
    }
  }

  private var headerBar: some View {
    HStack {
      Spacer()
      if !viewModel.isLastPage {
        Button("Skip", action: viewModel.skip)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(AppColor.secondaryText)
          .padding(.horizontal, 14)
          .padding(.vertical, 8)
          .appCard(elevation: .flat)
      }
    }
    .padding(.horizontal, AppSpacing.lg)
    .padding(.top, AppSpacing.sm)
    .frame(height: 44)
  }

  private var footer: some View {
    VStack(spacing: AppSpacing.lg) {
      pageIndicator

      PrimaryButton(
        title: viewModel.primaryButtonTitle,
        icon: viewModel.isLastPage ? "checkmark.circle.fill" : "arrow.right.circle.fill",
        action: viewModel.next
      )
      .padding(.horizontal, AppSpacing.lg)
    }
    .padding(.bottom, AppSpacing.xl)
  }

  private var pageIndicator: some View {
    HStack(spacing: 8) {
      ForEach(viewModel.pages) { page in
        Capsule()
          .fill(
            page.id == viewModel.currentPage
              ? AnyShapeStyle(AppGradients.accentButton)
              : AnyShapeStyle(AppColor.secondaryText.opacity(0.25))
          )
          .frame(width: page.id == viewModel.currentPage ? 24 : 8, height: 8)
          .animation(.easeInOut(duration: 0.25), value: viewModel.currentPage)
      }
    }
  }
}

private struct OnboardingPageView: View {
  let page: OnboardingPage

  var body: some View {
    ScrollView {
      VStack(spacing: AppSpacing.xl) {
        heroCard
        textBlock
        featuresCard
      }
      .padding(.horizontal, AppSpacing.lg)
      .padding(.top, AppSpacing.md)
      .padding(.bottom, AppSpacing.lg)
    }
    .clearScrollBackground()
  }

  private var heroCard: some View {
    ZStack(alignment: .bottomLeading) {
      Image(page.imageName)
        .resizable()
        .scaledToFill()
        .frame(height: 220)
        .clipped()

      LinearGradient(
        colors: [.clear, AppColor.background.opacity(0.5), AppColor.background.opacity(0.92)],
        startPoint: .top,
        endPoint: .bottom
      )

      HStack(spacing: AppSpacing.sm) {
        Text(page.emoji)
          .font(.system(size: 36))
        Text(page.title)
          .font(.title2.weight(.bold))
          .foregroundColor(AppColor.primaryText)
      }
      .padding(AppSpacing.lg)
    }
    .frame(height: 220)
    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
        .stroke(
          LinearGradient(
            colors: [page.tint.opacity(0.7), page.tint.opacity(0.15)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          ),
          lineWidth: 1.5
        )
    )
    .compositingGroup()
    .shadow(color: page.tint.opacity(0.38), radius: 18, y: 8)
  }

  private var textBlock: some View {
    VStack(spacing: AppSpacing.sm) {
      Text(page.title)
        .font(.title.weight(.bold))
        .foregroundStyle(AppGradients.sectionTitle)

      Text(page.subtitle)
        .font(.subheadline)
        .foregroundColor(AppColor.secondaryText)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
    }
    .frame(maxWidth: .infinity)
  }

  private var featuresCard: some View {
    VStack(spacing: AppSpacing.sm) {
      ForEach(page.features) { feature in
        HStack(spacing: AppSpacing.md) {
          ZStack {
            RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
              .fill(AppGradients.tinted(page.tint))
              .frame(width: 40, height: 40)
            Image(systemName: feature.icon)
              .font(.body.weight(.semibold))
              .foregroundColor(page.tint)
          }

          Text(feature.text)
            .font(.subheadline)
            .foregroundColor(AppColor.primaryText)

          Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
        .appCard(elevation: .raised, border: page.tint.opacity(0.3), tint: page.tint)
      }
    }
  }
}

#Preview {
  OnboardingView(onComplete: {})
    .preferredColorScheme(.dark)
}
