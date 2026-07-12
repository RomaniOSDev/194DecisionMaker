import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @AppStorage(StorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                coordinator.start()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "0A0E22").ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
