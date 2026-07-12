import SwiftUI
import Combine

@MainActor
final class ImportExportViewModel: ObservableObject {
    @Published var exportText = ""
    @Published var importText = ""
    @Published var message: String?
    @Published var isError = false

    private let storageService: StorageServiceProtocol
    private let coordinator: AppCoordinator
    private let importExportService: ImportExportService

    init(
        storageService: StorageServiceProtocol,
        coordinator: AppCoordinator,
        importExportService: ImportExportService
    ) {
        self.storageService = storageService
        self.coordinator = coordinator
        self.importExportService = importExportService
        refreshExportText()
    }

    var exportData: Data? {
        let collections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        let options: [Option] = storageService.load(forKey: StorageKeys.options)
        return try? importExportService.exportPackage(collections: collections, options: options)
    }

    func refreshExportText() {
        let collections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
        let options: [Option] = storageService.load(forKey: StorageKeys.options)
        exportText = importExportService.exportText(collections: collections, options: options)
    }

    func importFromPastedJSON(merge: Bool) {
        guard let data = importText.data(using: .utf8) else {
            show("Invalid text data.", error: true)
            return
        }
        do {
            try importExportService.importPackage(
                from: data,
                storageService: storageService,
                merge: merge
            )
            refreshExportText()
            show(merge ? "Lists merged successfully." : "Lists replaced successfully.")
        } catch {
            show(error.localizedDescription, error: true)
        }
    }

    func importFromData(_ data: Data, merge: Bool) {
        do {
            try importExportService.importPackage(
                from: data,
                storageService: storageService,
                merge: merge
            )
            refreshExportText()
            show(merge ? "File merged successfully." : "File imported successfully.")
        } catch {
            show(error.localizedDescription, error: true)
        }
    }

    private func show(_ text: String, error: Bool = false) {
        message = text
        isError = error
    }

    func goBack() { coordinator.pop() }
}
