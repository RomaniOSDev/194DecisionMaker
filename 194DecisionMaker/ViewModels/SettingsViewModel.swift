import SwiftUI
import Combine
import StoreKit
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var rules: SmartRules

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator

    init(storageService: StorageServiceProtocol, coordinator: AppCoordinator) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.rules = storageService.loadObject(forKey: StorageKeys.smartRules) ?? .default
    }

    func saveRules() {
        storageService.saveObject(rules, forKey: StorageKeys.smartRules)
    }

    func resetAllData() {
        storageService.delete(forKey: StorageKeys.options)
        storageService.delete(forKey: StorageKeys.history)
        storageService.delete(forKey: StorageKeys.statistics)
        storageService.delete(forKey: StorageKeys.collections)
        storageService.delete(forKey: StorageKeys.smartRules)
        coordinator.popToRoot()
    }

    func goToImportExport() { coordinator.navigateToImportExport() }
    func goBack() { coordinator.pop() }

    func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }

    func openPrivacyPolicy() {
        openLink(.privacyPolicy)
    }

    func openTermsOfUse() {
        openLink(.termsOfUse)
    }

    private func openLink(_ link: AppLink) {
        if let url = link.url {
            UIApplication.shared.open(url)
        }
    }
}
