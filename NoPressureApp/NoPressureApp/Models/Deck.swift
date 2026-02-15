import Foundation
import SwiftData

@Model
final class Deck {
    var id: UUID
    var name: String
    var deckDescription: String
    @Relationship(deleteRule: .cascade, inverse: \Flashcard.deck)
    var cards: [Flashcard]
    var colorHex: String
    var icon: String
    var createdAt: Date
    var lastStudied: Date?

    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        cards: [Flashcard] = [],
        colorHex: String = "#5533FF",
        icon: String = "folder.fill",
        createdAt: Date = Date(),
        lastStudied: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.deckDescription = description
        self.cards = cards
        self.colorHex = colorHex
        self.icon = icon
        self.createdAt = createdAt
        self.lastStudied = lastStudied
    }
}
