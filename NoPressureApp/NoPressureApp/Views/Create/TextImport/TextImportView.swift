import SwiftUI
import SwiftData

struct TextImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var inputText = ""
    @State private var isGenerating = false
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    private let aiService = AIGenerationService()
    private let characterLimit = 5000

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                if showingReview {
                    ReviewGeneratedCardsView(
                        cards: $generatedCards,
                        onSave: { deckName, deckDescription, colorHex, icon in
                            saveDeck(name: deckName, description: deckDescription, color: colorHex, icon: icon)
                        },
                        onCancel: {
                            showingReview = false
                            generatedCards = []
                        }
                    )
                } else {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Instructions
                        VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                            Text("Paste or type text")
                                .font(NP.Typography.title1)
                                .foregroundColor(NP.Colors.textBlack)

                            Text("Add text from notes, articles, or any source")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.xl)

                        // Text Editor
                        VStack(spacing: NP.Spacing.md) {
                            TextEditor(text: $inputText)
                                .font(NP.Typography.body)
                                .foregroundColor(NP.Colors.textPrimary)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 300)
                                .padding(NP.Spacing.lg)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                                .shadow(color: NP.Shadow.cardColor, radius: NP.Shadow.cardRadius, x: NP.Shadow.cardX, y: NP.Shadow.cardY)

                            HStack {
                                Text("\(inputText.count)/\(characterLimit) characters")
                                    .font(NP.Typography.caption2)
                                    .foregroundColor(NP.Colors.textSecondary)

                                Spacer()

                                if !inputText.isEmpty {
                                    Button("Clear") {
                                        inputText = ""
                                    }
                                    .font(NP.Typography.caption1Semibold)
                                    .foregroundColor(Color(hex: "#FF453A"))
                                }
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)

                        // Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(NP.Typography.caption1)
                                .foregroundColor(Color(hex: "#FF453A"))
                                .padding(.horizontal, NP.Spacing.xxl)
                                .multilineTextAlignment(.center)
                        }

                        Spacer()

                        // Generate Button
                        Button {
                            Task {
                                await generateFlashcards()
                            }
                        } label: {
                            HStack(spacing: NP.Spacing.md) {
                                if isGenerating {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "sparkles")
                                        .font(NP.Typography.IconSize.sm)
                                }

                                Text(isGenerating ? "Generating..." : "Generate Flashcards")
                                    .font(NP.Typography.bodySemibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(NP.Colors.primary)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                        .disabled(inputText.isEmpty || isGenerating || inputText.count > characterLimit)
                        .opacity(inputText.isEmpty || inputText.count > characterLimit ? 0.5 : 1.0)

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationTitle("Text Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingReview {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(NP.Colors.primary)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text(saveErrorMessage)
        }
    }

    private func generateFlashcards() async {
        guard !inputText.isEmpty else { return }

        isGenerating = true
        errorMessage = nil

        do {
            let cards = try await aiService.generateFlashcards(from: inputText)

            await MainActor.run {
                generatedCards = cards
                showingReview = true
                isGenerating = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isGenerating = false
            }
        }
    }

    private func saveDeck(name: String, description: String?, color: String, icon: String) {
        let deck = Deck(
            name: name,
            description: description,
            colorHex: color,
            icon: icon
        )
        modelContext.insert(deck)

        for card in generatedCards {
            let flashcard = Flashcard(
                front: card.front,
                back: card.back,
                deck: deck
            )
            modelContext.insert(flashcard)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            showSaveError = true
            saveErrorMessage = "Failed to save deck: \(error.localizedDescription)"
        }
    }
}

#Preview {
    TextImportView()
}
