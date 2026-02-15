import Foundation

/// Service for generating flashcards using OpenRouter API (Claude 3.5 Sonnet)
actor AIGenerationService {
    private let apiKey = Config.openRouterAPIKey
    private let baseURL = "https://openrouter.ai/api/v1/chat/completions"
    private let model = "anthropic/claude-3.5-sonnet"

    enum AIError: LocalizedError {
        case invalidURL
        case networkError(Error)
        case invalidResponse
        case jsonParsingError(Error)
        case apiError(String)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid API URL"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .invalidResponse:
                return "Invalid response from AI service"
            case .jsonParsingError(let error):
                return "Failed to parse response: \(error.localizedDescription)"
            case .apiError(let message):
                return "AI service error: \(message)"
            }
        }
    }

    /// Generate flashcards from text using AI
    /// - Parameter text: Source text to convert into flashcards
    /// - Returns: Array of generated flashcards
    func generateFlashcards(from text: String) async throws -> [GeneratedFlashcard] {
        guard let url = URL(string: baseURL) else {
            throw AIError.invalidURL
        }

        let prompt = createPrompt(for: text)
        let requestBody = createRequestBody(prompt: prompt)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AIError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw AIError.apiError(errorMessage)
            }

            return try parseResponse(data)
        } catch let error as AIError {
            throw error
        } catch {
            throw AIError.networkError(error)
        }
    }

    private func createPrompt(for text: String) -> String {
        """
        You are a flashcard generation expert. Convert the following text into flashcards.

        Rules:
        - Create 5-15 flashcards (depending on content length)
        - Each card should have a clear question (front) and concise answer (back)
        - Focus on key concepts, definitions, and important facts
        - Make questions specific and answers factual
        - Use simple, clear language
        - Return ONLY valid JSON, no additional text

        Format your response as JSON:
        {
          "cards": [
            {"front": "Question here?", "back": "Answer here"},
            {"front": "What is...?", "back": "The answer is..."}
          ]
        }

        Text to convert:
        \(text)
        """
    }

    private struct RequestBody: Codable {
        let model: String
        let messages: [Message]
        let temperature: Double
        let maxTokens: Int

        struct Message: Codable {
            let role: String
            let content: String
        }

        enum CodingKeys: String, CodingKey {
            case model
            case messages
            case temperature
            case maxTokens = "max_tokens"
        }
    }

    private func createRequestBody(prompt: String) -> RequestBody {
        RequestBody(
            model: model,
            messages: [
                RequestBody.Message(role: "user", content: prompt)
            ],
            temperature: 0.7,
            maxTokens: 2000
        )
    }

    private struct OpenRouterResponse: Codable {
        let choices: [Choice]

        struct Choice: Codable {
            let message: Message
        }

        struct Message: Codable {
            let content: String
        }
    }

    private struct FlashcardResponse: Codable {
        let cards: [GeneratedFlashcard]
    }

    private func parseResponse(_ data: Data) throws -> [GeneratedFlashcard] {
        do {
            let response = try JSONDecoder().decode(OpenRouterResponse.self, from: data)

            // Validate response has choices
            guard !response.choices.isEmpty else {
                throw AIError.invalidResponse
            }

            guard let content = response.choices.first?.message.content, !content.isEmpty else {
                throw AIError.invalidResponse
            }

            // Extract JSON from response (might be wrapped in markdown code blocks)
            let jsonString = extractJSON(from: content)

            guard let jsonData = jsonString.data(using: .utf8) else {
                throw AIError.invalidResponse
            }

            let flashcardResponse = try JSONDecoder().decode(FlashcardResponse.self, from: jsonData)

            // Validate we have at least one card
            guard !flashcardResponse.cards.isEmpty else {
                throw AIError.apiError("AI generated no flashcards. Try with different text.")
            }

            return flashcardResponse.cards

        } catch let error as AIError {
            throw error
        } catch {
            throw AIError.jsonParsingError(error)
        }
    }

    private func extractJSON(from text: String) -> String {
        // Remove markdown code blocks if present
        var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if cleaned.hasPrefix("```json") {
            cleaned = String(cleaned.dropFirst(7))
        } else if cleaned.hasPrefix("```") {
            cleaned = String(cleaned.dropFirst(3))
        }

        if cleaned.hasSuffix("```") {
            cleaned = String(cleaned.dropLast(3))
        }

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
