import Foundation
import FSRS

enum AppRating: Int {
    case again = 1
    case hard = 2
    case good = 3
    case easy = 4

    var fsrsRating: Rating {
        switch self {
        case .again: return .again
        case .hard: return .hard
        case .good: return .good
        case .easy: return .easy
        }
    }
}

class FSRSService {
    private let fsrs: FSRS

    init() {
        self.fsrs = FSRS(parameters: FSRSParameters())
    }

    func processReview(card: Flashcard, rating: AppRating, now: Date = Date()) -> FSRSData {
        let fsrsData = card.fsrsData

        // Create FSRS Card from our model (or a fresh .new card if no FSRS data yet)
        let fsrsCard = Card(
            due: fsrsData?.nextReview ?? now,
            stability: fsrsData?.stability ?? 0,
            difficulty: fsrsData?.difficulty ?? 0,
            elapsedDays: 0,
            scheduledDays: 0,
            reps: fsrsData?.reps ?? 0,
            lapses: fsrsData?.lapses ?? 0,
            state: (fsrsData?.reps ?? 0) == 0 ? .new : .review
        )

        // Create SchedulingInfo
        let schedulingInfo = fsrs.repeat(card: fsrsCard, now: now)

        // Get the appropriate record based on rating (using FSRS Rating enum)
        // Use safe optional binding with fallback to .good rating
        guard let recordingLog = schedulingInfo[rating.fsrsRating] ?? schedulingInfo[.good] else {
            // Fallback: return current FSRSData or a new one if scheduling info is completely missing
            return fsrsData ?? FSRSData()
        }

        // Update FSRSData
        let updatedData = FSRSData(
            difficulty: recordingLog.card.difficulty,
            stability: recordingLog.card.stability,
            retrievability: 0.9, // Will be calculated by FSRS
            lastReview: now,
            nextReview: recordingLog.card.due,
            reps: recordingLog.card.reps,
            lapses: recordingLog.card.lapses
        )

        return updatedData
    }

    func getDueCards(from decks: [Deck], at date: Date = Date()) -> [Flashcard] {
        var dueCards: [Flashcard] = []

        for deck in decks {
            for card in deck.cards {
                guard let fsrsData = card.fsrsData else {
                    // Cards with no FSRS data are new — always due
                    dueCards.append(card)
                    continue
                }

                // Card is due if nextReview is nil or nextReview is before/equal to current date
                if let nextReview = fsrsData.nextReview {
                    if nextReview <= date {
                        dueCards.append(card)
                    }
                } else {
                    // nextReview is nil — treat as due
                    dueCards.append(card)
                }
            }
        }

        return dueCards
    }
}
