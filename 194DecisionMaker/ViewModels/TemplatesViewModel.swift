import SwiftUI
import Combine

@MainActor
final class TemplatesViewModel: ObservableObject {
    @Published var templates: [DecisionTemplate] = []
    @Published var appliedMessage: String?

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let templateService: TemplateService

    init(
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        templateService: TemplateService
    ) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.templateService = templateService
        templates = templateService.templates
    }

    func apply(_ template: DecisionTemplate) {
        let collection = templateService.apply(template: template, storageService: storageService)
        appliedMessage = "\(collection.emoji) \(collection.name) added!"
    }

    func goBack() { coordinator.pop() }
}
