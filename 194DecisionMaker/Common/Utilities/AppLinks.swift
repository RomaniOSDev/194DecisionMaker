import Foundation

enum AppLink: String {
    case privacyPolicy = "https://www.termsfeed.com/live/11f64edd-2c31-459b-8ca2-66b2989dadf7"
    case termsOfUse = "https://www.termsfeed.com/live/22da5945-dbcb-4822-82e6-6cea1b8c566f"

    var url: URL? {
        URL(string: rawValue)
    }
}
