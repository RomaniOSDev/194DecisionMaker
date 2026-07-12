import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
  @Published var currentPage = 0

  let pages = OnboardingPage.all
  private let onComplete: () -> Void

  var isLastPage: Bool { currentPage == pages.count - 1 }

  var primaryButtonTitle: String {
    isLastPage ? "Get Started" : "Continue"
  }

  init(onComplete: @escaping () -> Void) {
    self.onComplete = onComplete
  }

  func next() {
    if isLastPage {
      complete()
    } else {
      withAnimation(.easeInOut(duration: 0.3)) {
        currentPage += 1
      }
    }
  }

  func skip() {
    complete()
  }

  func complete() {
    UserDefaults.standard.set(true, forKey: StorageKeys.hasCompletedOnboarding)
    onComplete()
  }
}
