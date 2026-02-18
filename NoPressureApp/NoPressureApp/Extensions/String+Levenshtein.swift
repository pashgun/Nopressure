import Foundation

extension String {
    /// Calculate Levenshtein distance between two strings
    /// - Parameter other: String to compare against
    /// - Returns: Minimum number of edits needed to transform one string into another
    func levenshteinDistance(to other: String) -> Int {
        let selfCount = self.count
        let otherCount = other.count

        if selfCount == 0 {
            return otherCount
        }

        if otherCount == 0 {
            return selfCount
        }

        var matrix = [[Int]](repeating: [Int](repeating: 0, count: otherCount + 1), count: selfCount + 1)

        for i in 0...selfCount {
            matrix[i][0] = i
        }

        for j in 0...otherCount {
            matrix[0][j] = j
        }

        for i in 1...selfCount {
            for j in 1...otherCount {
                let cost = self[self.index(self.startIndex, offsetBy: i - 1)] == other[other.index(other.startIndex, offsetBy: j - 1)] ? 0 : 1

                matrix[i][j] = Swift.min(
                    matrix[i - 1][j] + 1,      // deletion
                    matrix[i][j - 1] + 1,      // insertion
                    matrix[i - 1][j - 1] + cost // substitution
                )
            }
        }

        return matrix[selfCount][otherCount]
    }

    /// Calculate similarity percentage between two strings
    /// - Parameter other: String to compare against
    /// - Returns: Similarity as percentage (0.0 - 1.0)
    func similarity(to other: String) -> Double {
        let distance = levenshteinDistance(to: other)
        let maxLength = max(self.count, other.count)

        guard maxLength > 0 else {
            return 1.0 // Both strings are empty
        }

        return Double(maxLength - distance) / Double(maxLength)
    }

    /// Check if answer is close enough to be considered correct
    /// - Parameters:
    ///   - correctAnswer: The correct answer
    ///   - threshold: Minimum similarity required (default 0.8 = 80%)
    /// - Returns: Whether the answer is close enough
    func isSimilarEnough(to correctAnswer: String, threshold: Double = 0.8) -> Bool {
        // Normalize both strings (lowercase, trim whitespace)
        let normalizedSelf = self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedCorrect = correctAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        // Exact match
        if normalizedSelf == normalizedCorrect {
            return true
        }

        // Calculate similarity
        let similarity = normalizedSelf.similarity(to: normalizedCorrect)
        return similarity >= threshold
    }
}
