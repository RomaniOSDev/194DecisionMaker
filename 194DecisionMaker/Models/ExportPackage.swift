import Foundation

struct ExportPackage: Codable {
    let version: Int
    let exportedAt: Date
    var collections: [OptionCollection]
    var options: [Option]

    static let currentVersion = 1
}
