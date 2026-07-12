import Foundation

enum ImportExportError: LocalizedError {
    case invalidData
    case decodeFailed

    var errorDescription: String? {
        switch self {
        case .invalidData: return "Invalid import data."
        case .decodeFailed: return "Could not read the file."
        }
    }
}

final class ImportExportService {
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func exportPackage(
        collections: [OptionCollection],
        options: [Option]
    ) throws -> Data {
        let package = ExportPackage(
            version: ExportPackage.currentVersion,
            exportedAt: Date(),
            collections: collections,
            options: options
        )
        return try encoder.encode(package)
    }

    func exportText(
        collections: [OptionCollection],
        options: [Option]
    ) -> String {
        var lines: [String] = ["# Decision Lists Export", ""]
        for collection in collections {
            lines.append("\(collection.emoji) \(collection.name) [\(collection.category.rawValue)]")
            let collectionOptions = options.filter { $0.collectionId == collection.id }
            for option in collectionOptions {
                lines.append("  - \(option.emoji) \(option.text) (weight: \(option.weight))")
            }
            lines.append("")
        }
        let uncategorized = options.filter { $0.collectionId == nil }
        if !uncategorized.isEmpty {
            lines.append("📋 Uncategorized")
            for option in uncategorized {
                lines.append("  - \(option.emoji) \(option.text)")
            }
        }
        return lines.joined(separator: "\n")
    }

    func importPackage(
        from data: Data,
        storageService: StorageServiceProtocol,
        merge: Bool
    ) throws {
        let package = try decoder.decode(ExportPackage.self, from: data)

        if merge {
            var collections: [OptionCollection] = storageService.load(forKey: StorageKeys.collections)
            var options: [Option] = storageService.load(forKey: StorageKeys.options)
            collections.append(contentsOf: package.collections)
            options.append(contentsOf: package.options)
            storageService.save(collections, forKey: StorageKeys.collections)
            storageService.save(options, forKey: StorageKeys.options)
        } else {
            storageService.save(package.collections, forKey: StorageKeys.collections)
            storageService.save(package.options, forKey: StorageKeys.options)
        }
    }
}
