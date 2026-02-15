import Foundation

/// Temporary model for AI-generated flashcards before saving to SwiftData
struct GeneratedFlashcard: Codable, Identifiable {
    var id = UUID()
    var front: String
    var back: String

    enum CodingKeys: String, CodingKey {
        case front
        case back
    }
}

/// Response from AI generation service
struct FlashcardGenerationResponse: Codable {
    let cards: [GeneratedFlashcard]
    let suggestedDeckName: String?
    let suggestedDescription: String?
}
