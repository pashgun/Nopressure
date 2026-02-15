import Foundation
import FSRS

extension FSRSData {
    /// Convert FSRSData to FSRS library Card type
    func convertToCard() -> Card {
        let now = Date()
        return Card(
            due: nextReview ?? now,
            stability: stability,
            difficulty: difficulty,
            elapsedDays: 0,
            scheduledDays: 0,
            reps: reps,
            lapses: lapses,
            state: reps == 0 ? .new : .review
        )
    }

    /// Update FSRSData from FSRS library Card
    func update(from card: Card) {
        self.difficulty = card.difficulty
        self.stability = card.stability
        self.reps = card.reps
        self.lapses = card.lapses
        self.nextReview = card.due
        self.lastReview = Date()
    }
}
