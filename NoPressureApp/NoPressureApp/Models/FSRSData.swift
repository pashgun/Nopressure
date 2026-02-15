import Foundation
import SwiftData

@Model
final class FSRSData {
    var difficulty: Double
    var stability: Double
    var retrievability: Double
    var lastReview: Date?
    var nextReview: Date?
    var reps: Int
    var lapses: Int

    init(
        difficulty: Double = 0.0,
        stability: Double = 0.0,
        retrievability: Double = 0.0,
        lastReview: Date? = nil,
        nextReview: Date? = nil,
        reps: Int = 0,
        lapses: Int = 0
    ) {
        self.difficulty = difficulty
        self.stability = stability
        self.retrievability = retrievability
        self.lastReview = lastReview
        self.nextReview = nextReview
        self.reps = reps
        self.lapses = lapses
    }
}
