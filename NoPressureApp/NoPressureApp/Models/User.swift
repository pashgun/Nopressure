import Foundation
import SwiftData

enum LearningGoal: String, Codable {
    case exams
    case language
    case professional
    case general
}

@Model
final class User {
    var id: UUID
    var name: String
    var email: String
    var goal: LearningGoal
    var dailyMinutes: Int
    var interests: [String]
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        email: String = "",
        goal: LearningGoal = .general,
        dailyMinutes: Int = 15,
        interests: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.goal = goal
        self.dailyMinutes = dailyMinutes
        self.interests = interests
        self.createdAt = createdAt
    }
}
