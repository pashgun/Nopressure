import Foundation
import SwiftData
import os

private let logger = Logger(subsystem: "com.nopressure.app", category: "UserService")

/// Service for managing User operations in SwiftData
@MainActor
class UserService {
    /// Get the current user from SwiftData
    /// - Parameter context: The ModelContext to query
    /// - Returns: The first User found, or nil if no user exists
    static func getCurrentUser(from context: ModelContext) -> User? {
        let descriptor = FetchDescriptor<User>()
        do {
            return try context.fetch(descriptor).first
        } catch {
            logger.error("Failed to fetch user: \(error.localizedDescription)")
            return nil
        }
    }

    /// Create a new user and save to SwiftData
    /// - Parameters:
    ///   - name: User's name
    ///   - email: User's email
    ///   - goal: Learning goal
    ///   - dailyMinutes: Daily study time in minutes
    ///   - interests: Array of interest topics
    ///   - context: ModelContext to save to
    /// - Returns: The created User
    static func createUser(
        name: String,
        email: String,
        goal: LearningGoal,
        dailyMinutes: Int,
        interests: [String],
        in context: ModelContext
    ) -> User {
        let user = User(
            name: name,
            email: email,
            goal: goal,
            dailyMinutes: dailyMinutes,
            interests: interests
        )

        context.insert(user)
        do {
            try context.save()
        } catch {
            logger.error("Failed to save new user: \(error.localizedDescription)")
        }

        return user
    }

    /// Update existing user
    /// - Parameters:
    ///   - user: User to update
    ///   - context: ModelContext
    static func updateUser(_ user: User, in context: ModelContext) {
        do {
            try context.save()
        } catch {
            logger.error("Failed to update user: \(error.localizedDescription)")
        }
    }

    /// Delete user
    /// - Parameters:
    ///   - user: User to delete
    ///   - context: ModelContext
    static func deleteUser(_ user: User, in context: ModelContext) {
        context.delete(user)
        do {
            try context.save()
        } catch {
            logger.error("Failed to delete user: \(error.localizedDescription)")
        }
    }
}
