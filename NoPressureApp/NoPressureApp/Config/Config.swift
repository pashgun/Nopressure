import Foundation

enum Config {
    /// OpenRouter API key for AI flashcard generation
    /// Loaded from Info.plist which references Config.xcconfig
    static let openRouterAPIKey: String = {
        guard let key = Bundle.main.infoDictionary?["OPENROUTER_API_KEY"] as? String,
              !key.isEmpty,
              key != "$(OPENROUTER_API_KEY)" else {
            fatalError("OPENROUTER_API_KEY not configured in Config.xcconfig or Info.plist")
        }
        return key
    }()
}
