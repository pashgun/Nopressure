import SwiftUI
import SwiftData
import FSRS

struct WriteModeView: View {
    let cards: [Flashcard]
    let onComplete: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var isAnswered = false
    @State private var isCorrect = false
    @State private var score = 0
    @State private var showHint = false
    @State private var showError = false
    @State private var errorMessage = ""

    private let fsrsService = FSRSService()
    private let similarityThreshold = 0.8 // 80% similarity required

    var body: some View {
        if cards.isEmpty {
            VStack(spacing: NP.Spacing.lg) {
                Text("No cards available")
                    .font(NP.Typography.title3)
                    .foregroundColor(NP.Colors.textSecondary)
                Button("Go Back") { onComplete() }
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.primary)
            }
        } else {
        VStack(spacing: NP.Spacing.xxxl) {
            // Progress
            VStack(spacing: NP.Spacing.md) {
                HStack {
                    Text("Question \(currentIndex + 1) of \(cards.count)")
                        .font(NP.Typography.subheadlineSemibold)
                        .foregroundColor(NP.Colors.textSecondary)

                    Spacer()

                    Text("Score: \(score)/\(currentIndex + (isAnswered ? 1 : 0))")
                        .font(NP.Typography.subheadlineSemibold)
                        .foregroundColor(NP.Colors.primary)
                }

                ProgressView(value: Double(currentIndex), total: Double(cards.count))
                    .tint(NP.Colors.primary)
            }
            .padding(.horizontal, NP.Spacing.xxl)
            .padding(.top, NP.Spacing.xl)

            Spacer()

            // Question Card
            if let card = currentCardSafe {
                VStack(spacing: NP.Spacing.xl) {
                    Text(card.front)
                        .font(NP.Typography.questionTitle)
                        .foregroundColor(NP.Colors.textBlack)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, NP.Spacing.xxxl)
                        .padding(.vertical, 40)
                }
                .frame(maxWidth: .infinity)
                .background(NP.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.xl, style: .continuous))
                .shadow(color: NP.Shadow.cardColor, radius: NP.Shadow.cardRadius, x: NP.Shadow.cardX, y: NP.Shadow.cardY)
                .padding(.horizontal, NP.Spacing.xxl)
            } else {
                Text("No card available")
                    .foregroundColor(NP.Colors.textSecondary)
            }

            // Answer Input
            VStack(spacing: NP.Spacing.lg) {
                TextField("Type your answer", text: $userAnswer)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)
                    .padding(NP.Spacing.xl)
                    .background(
                        RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous)
                            .fill(answerBackgroundColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous)
                                    .strokeBorder(answerBorderColor, lineWidth: 2)
                            )
                    )
                    .disabled(isAnswered)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                // Hint Button
                if !isAnswered && !showHint {
                    Button("Show Hint") {
                        showHint = true
                    }
                    .font(NP.Typography.subheadlineSemibold)
                    .foregroundColor(NP.Colors.textSecondary)
                }

                // Hint
                if showHint && !isAnswered {
                    Text(getHint())
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .padding(.horizontal, NP.Spacing.xl)
                }

                // Feedback
                if isAnswered {
                    VStack(spacing: NP.Spacing.md) {
                        HStack(spacing: NP.Spacing.sm) {
                            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isCorrect ? Color(hex: "#30D158") : Color(hex: "#FF453A"))

                            Text(isCorrect ? "Correct!" : "Not quite")
                                .font(NP.Typography.bodySemibold)
                                .foregroundColor(NP.Colors.textBlack)
                        }

                        if !isCorrect, let card = currentCardSafe {
                            VStack(spacing: NP.Spacing.xs) {
                                Text("Correct answer:")
                                    .font(NP.Typography.caption1)
                                    .foregroundColor(NP.Colors.textSecondary)

                                Text(card.back)
                                    .font(NP.Typography.bodySemibold)
                                    .foregroundColor(Color(hex: "#30D158"))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, NP.Spacing.sm)
                        }
                    }
                    .padding(NP.Spacing.xl)
                    .frame(maxWidth: .infinity)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                    .shadow(color: NP.Shadow.cardColor, radius: 8, x: 0, y: 4)
                }
            }
            .padding(.horizontal, NP.Spacing.xxl)

            Spacer()

            // Action Button
            Button {
                if isAnswered {
                    moveToNext()
                } else {
                    checkAnswer()
                }
            } label: {
                Text(isAnswered ? (currentIndex < cards.count - 1 ? "Next" : "Finish") : "Submit")
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(NP.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            }
            .padding(.horizontal, NP.Spacing.xxl)
            .padding(.bottom, 60)
            .disabled(!isAnswered && userAnswer.isEmpty)
            .opacity(!isAnswered && userAnswer.isEmpty ? 0.5 : 1.0)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        } // else (cards not empty)
    }

    private var currentCardSafe: Flashcard? {
        guard currentIndex >= 0 && currentIndex < cards.count else {
            return nil
        }
        return cards[currentIndex]
    }

    private var answerBackgroundColor: Color {
        if !isAnswered {
            return NP.Colors.surface
        }
        return isCorrect ? Color(hex: "#30D158").opacity(0.12) : Color(hex: "#FF453A").opacity(0.12)
    }

    private var answerBorderColor: Color {
        if !isAnswered {
            return Color.black.opacity(0.08)
        }
        return isCorrect ? Color(hex: "#30D158") : Color(hex: "#FF453A")
    }

    private func getHint() -> String {
        guard let card = currentCardSafe else {
            return "No hint available"
        }

        let answer = card.back
        let wordCount = answer.split(separator: " ").count

        if wordCount == 1 {
            // Show first letter
            return "Hint: Starts with '\(answer.prefix(1))'"
        } else {
            // Show word count
            return "Hint: \(wordCount) words"
        }
    }

    private func checkAnswer() {
        guard let card = currentCardSafe else {
            return
        }

        isAnswered = true
        isCorrect = userAnswer.isSimilarEnough(to: card.back, threshold: similarityThreshold)

        if isCorrect {
            score += 1
            updateFSRS(rating: .good)
        } else {
            updateFSRS(rating: .again)
        }
    }

    private func updateFSRS(rating: AppRating) {
        guard let card = currentCardSafe else {
            return
        }

        // Use FSRSService.processReview instead of non-existent repeat method
        let updatedFSRS = fsrsService.processReview(card: card, rating: rating, now: Date())
        card.fsrsData = updatedFSRS

        do {
            try modelContext.save()
        } catch {
            showError = true
            errorMessage = "Failed to save progress: \(error.localizedDescription)"
        }
    }

    private func moveToNext() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
            userAnswer = ""
            isAnswered = false
            isCorrect = false
            showHint = false
        } else {
            onComplete()
        }
    }
}

#Preview {
    WriteModeView(cards: [], onComplete: {})
}
