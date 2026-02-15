import SwiftUI
import SwiftData
import FabrikaAnalytics

struct StudySessionView: View {
    let deck: Deck
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.analyticsService) private var analytics

    @State private var currentCardIndex = 0
    @State private var isFlipped = false
    @State private var cardsReviewed = 0
    @State private var showingComplete = false
    @State private var sessionStartTime = Date()
    @State private var studyMode: StudyMode = .flashcard
    @State private var showError = false
    @State private var errorMessage = ""

    private let fsrsService = FSRSService()

    var dueCards: [Flashcard] {
        deck.cards.filter { card in
            guard let nextReview = card.fsrsData?.nextReview else { return true }
            return nextReview <= Date()
        }
    }

    var currentCard: Flashcard? {
        guard currentCardIndex < dueCards.count else { return nil }
        return dueCards[currentCardIndex]
    }

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(NP.Colors.textPrimary)
                            .padding(12)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                            .shadow(color: NP.Shadow.cardColor, radius: 4, x: 0, y: 2)
                    }

                    Spacer()

                    Text("\(currentCardIndex + 1) / \(dueCards.count)")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(NP.Colors.textPrimary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(NP.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                        .shadow(color: NP.Shadow.cardColor, radius: 4, x: 0, y: 2)

                    Spacer()

                    Color.clear
                        .frame(width: 48, height: 48)
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.top, 20)

                // Study Mode Selector
                StudyModeSelector(selectedMode: $studyMode)
                    .padding(.top, NP.Spacing.lg)

                // Content based on study mode
                switch studyMode {
                case .flashcard:
                    flashcardModeView
                case .quiz:
                    quizModeView
                case .write:
                    writeModeView
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingComplete) {
            SessionCompleteView(
                cardsReviewed: cardsReviewed,
                onDismiss: { dismiss() }
            )
        }
        .onAppear {
            sessionStartTime = Date()

            let event = FlashcardEvent.studySessionStarted(
                deckName: deck.name,
                dueCardsCount: dueCards.count
            )
            analytics.track(event, context: modelContext)
        }
        .onDisappear {
            let duration = Date().timeIntervalSince(sessionStartTime)
            let event = FlashcardEvent.studySessionCompleted(
                cardsReviewed: cardsReviewed,
                duration: duration
            )
            analytics.track(event, context: modelContext)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Mode Views

    @ViewBuilder
    private var flashcardModeView: some View {
        VStack(spacing: 0) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(NP.Colors.lightPurple)
                        .frame(height: 4)

                    Rectangle()
                        .fill(NP.Colors.primary)
                        .frame(width: geometry.size.width * CGFloat(currentCardIndex) / CGFloat(max(dueCards.count, 1)), height: 4)
                }
            }
            .frame(height: 4)
            .clipShape(Capsule())
            .padding(.top, NP.Spacing.lg)
            .padding(.horizontal, NP.Spacing.xxl)

            Spacer()

            // Flashcard
            if let card = currentCard {
                FlipCard(
                    front: card.front,
                    back: card.back,
                    isFlipped: $isFlipped
                )
                .padding(.horizontal, NP.Spacing.xxxl)
            } else {
                Text("No cards to review")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textPrimary)
            }

            Spacer()

            // Rating Buttons (show only when flipped)
            if isFlipped {
                HStack(spacing: NP.Spacing.md) {
                    RatingButton(title: "Again", color: "#FF375F") {
                        rateCard(rating: .again)
                    }

                    RatingButton(title: "Hard", color: "#FF9F0A") {
                        rateCard(rating: .hard)
                    }

                    RatingButton(title: "Good", color: "#5533FF") {
                        rateCard(rating: .good)
                    }

                    RatingButton(title: "Easy", color: "#30D158") {
                        rateCard(rating: .easy)
                    }
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer().frame(height: 60)
        }
    }

    @ViewBuilder
    private var quizModeView: some View {
        QuizModeView(cards: dueCards) {
            showingComplete = true
            cardsReviewed = dueCards.count
        }
    }

    @ViewBuilder
    private var writeModeView: some View {
        WriteModeView(cards: dueCards) {
            showingComplete = true
            cardsReviewed = dueCards.count
        }
    }

    // MARK: - Card Rating

    private func rateCard(rating: AppRating) {
        guard let card = currentCard else { return }

        let updatedData = fsrsService.processReview(card: card, rating: rating)
        card.fsrsData = updatedData
        deck.lastStudied = Date()

        let cardAge = Date().timeIntervalSince(card.createdAt)
        let event = FlashcardEvent.cardRated(
            rating: "\(rating)",
            cardAge: cardAge
        )
        analytics.track(event, context: modelContext)

        do {
            try modelContext.save()
        } catch {
            showError = true
            errorMessage = "Failed to save progress: \(error.localizedDescription)"
        }

        cardsReviewed += 1

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isFlipped = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if currentCardIndex < dueCards.count - 1 {
                    currentCardIndex += 1
                } else {
                    showingComplete = true
                }
            }
        }
    }
}

struct FlipCard: View {
    let front: String
    let back: String
    @Binding var isFlipped: Bool

    var body: some View {
        ZStack {
            // Back side
            CardSide(text: back, isBack: true)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -90),
                    axis: (x: 0, y: 1, z: 0)
                )

            // Front side
            CardSide(text: front, isBack: false)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 90 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isFlipped.toggle()
            }
        }
    }
}

struct CardSide: View {
    let text: String
    let isBack: Bool

    var body: some View {
        VStack {
            Spacer()

            Text(text)
                .font(NP.Typography.cardFace)
                .foregroundColor(NP.Colors.textBlack)
                .multilineTextAlignment(.center)
                .padding(NP.Spacing.xxxl)

            Spacer()

            if !isBack {
                Text("Tap to reveal")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
                    .padding(.bottom, NP.Spacing.xxl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 400)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.xl, style: .continuous))
        .shadow(
            color: NP.Shadow.cardColor,
            radius: NP.Shadow.cardRadius,
            x: NP.Shadow.cardX,
            y: NP.Shadow.cardY
        )
    }
}

struct RatingButton: View {
    let title: String
    let color: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, NP.Spacing.lg)
                .background(Color(hex: color))
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
        }
    }
}

struct SessionCompleteView: View {
    let cardsReviewed: Int
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: NP.Spacing.xxxl) {
                Spacer()

                // Success icon
                ZStack {
                    Circle()
                        .fill(NP.Colors.lightPurple)
                        .frame(width: 120, height: 120)

                    Image("solar-check-circle-bold")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .foregroundColor(NP.Colors.primary)
                }

                VStack(spacing: NP.Spacing.md) {
                    Text("Great job!")
                        .font(NP.Typography.largeTitle)
                        .foregroundColor(NP.Colors.textBlack)

                    Text("You reviewed \(cardsReviewed) cards")
                        .font(NP.Typography.body)
                        .foregroundColor(NP.Colors.textSecondary)
                }

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text("Done")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(NP.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
