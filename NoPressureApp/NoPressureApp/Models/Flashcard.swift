import Foundation
import SwiftData

@Model
final class Flashcard {
    var id: UUID
    var front: String
    var back: String
    var fsrsData: FSRSData?
    var createdAt: Date
    var deck: Deck?

    init(
        id: UUID = UUID(),
        front: String,
        back: String,
        fsrsData: FSRSData? = nil,
        createdAt: Date = Date(),
        deck: Deck? = nil
    ) {
        self.id = id
        self.front = front
        self.back = back
        self.fsrsData = fsrsData ?? FSRSData()
        self.createdAt = createdAt
        self.deck = deck
    }
}
