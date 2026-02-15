import SwiftUI
import SwiftData
import FSRS

struct QuizModeView: View {
    let cards: [Flashcard]
    let onComplete: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var isAnswered = false
    @State private var score = 0
    @State private var options: [String] = ["", "", "", ""]  // Initialize with 4 empty strings to prevent index out of bounds
    @State private var showError = false
    @State private var errorMessage = ""

    private let fsrsService = FSRSService()

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
            VStack(spacing: NP.Spacing.xl) {
                Text(currentCard.front)
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

            // Answer Options
            VStack(spacing: NP.Spacing.lg) {
                ForEach(0..<4) { index in
                    AnswerButton(
                        text: options[index],
                        isSelected: selectedAnswer == index,
                        isCorrect: isAnswered && options[index] == currentCard.back,
                        isAnswered: isAnswered
                    ) {
                        guard !isAnswered else { return }
                        selectedAnswer = index
                        checkAnswer()
                    }
                }
            }
            .padding(.horizontal, NP.Spacing.xxl)

            Spacer()

            // Next Button
            if isAnswered {
                Button {
                    moveToNext()
                } label: {
                    Text(currentIndex < cards.count - 1 ? "Next" : "Finish")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(NP.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            generateOptions()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
        } // else (cards not empty)
    }

    private var currentCard: Flashcard {
        guard currentIndex < cards.count else { return cards[cards.count - 1] }
        return cards[currentIndex]
    }

    private func generateOptions() {
        var opts = [currentCard.back]

        // Get wrong answers from other cards
        let otherCards = cards.filter { $0.id != currentCard.id }
        let wrongAnswers = Array(otherCards.prefix(3).map { $0.back })

        opts.append(contentsOf: wrongAnswers)

        // Fill up to 4 options if needed (for decks with < 4 cards)
        while opts.count < 4 {
            opts.append("Option \(opts.count + 1)")
        }

        // Shuffle
        options = opts.shuffled()
    }

    private func checkAnswer() {
        isAnswered = true

        if let selected = selectedAnswer, options[selected] == currentCard.back {
            score += 1
            updateFSRS(rating: .good)
        } else {
            updateFSRS(rating: .again)
        }
    }

    private func updateFSRS(rating: AppRating) {
        let card = currentCard

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
            selectedAnswer = nil
            isAnswered = false
            generateOptions()
        } else {
            onComplete()
        }
    }
}

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isAnswered: Bool
    let action: () -> Void

    private var backgroundColor: Color {
        if !isAnswered {
            return isSelected ? NP.Colors.primary.opacity(0.1) : NP.Colors.surface
        }

        if isCorrect {
            return Color(hex: "#30D158").opacity(0.12)
        } else if isSelected {
            return Color(hex: "#FF453A").opacity(0.12)
        } else {
            return NP.Colors.surface
        }
    }

    private var borderColor: Color {
        if !isAnswered {
            return isSelected ? NP.Colors.primary : Color.black.opacity(0.08)
        }

        if isCorrect {
            return Color(hex: "#30D158")
        } else if isSelected {
            return Color(hex: "#FF453A")
        } else {
            return Color.black.opacity(0.08)
        }
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: NP.Spacing.lg) {
                Text(text)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if isAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "#30D158"))
                    } else if isSelected {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "#FF453A"))
                    }
                }
            }
            .padding(NP.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous)
                            .strokeBorder(borderColor, lineWidth: 2)
                    )
            )
            .shadow(color: NP.Shadow.cardColor, radius: 4, x: 0, y: 2)
        }
        .disabled(isAnswered)
    }
}

#Preview {
    QuizModeView(cards: [], onComplete: {})
}
