import SwiftUI
import SwiftData

struct ManualCreateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var deckName = ""
    @State private var deckDescription = ""
    @State private var selectedColor = "#5533FF"
    @State private var selectedIcon = "star.fill"
    @State private var cards: [CardDraft] = [CardDraft(), CardDraft()]
    @State private var showError = false
    @State private var errorMessage = ""

    let availableColors = [
        "#5533FF", // Purple (primary)
        "#FF7A4D", // Orange (accent)
        "#FF453A", // Red
        "#FF9F0A", // Orange
        "#30D158", // Green
        "#64D2FF", // Cyan
        "#FFD60A"  // Yellow
    ]

    let availableIcons = [
        "star.fill", "heart.fill", "book.fill", "globe",
        "brain.head.profile", "graduationcap.fill",
        "flag.fill", "lightbulb.fill", "sparkles"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Deck Details Section
                        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                            Text("Deck Details")
                                .font(NP.Typography.title2)
                                .foregroundColor(NP.Colors.textBlack)

                            // Deck Name
                            TextField("Deck name", text: $deckName)
                                .font(NP.Typography.bodySemibold)
                                .foregroundColor(NP.Colors.textPrimary)
                                .padding(NP.Spacing.lg)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                                .shadow(color: NP.Shadow.cardColor, radius: 8, x: 0, y: 4)

                            // Deck Description
                            TextField("Description (optional)", text: $deckDescription)
                                .font(NP.Typography.body)
                                .foregroundColor(NP.Colors.textPrimary)
                                .padding(NP.Spacing.lg)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                                .shadow(color: NP.Shadow.cardColor, radius: 8, x: 0, y: 4)

                            // Color Picker
                            VStack(alignment: .leading, spacing: NP.Spacing.md) {
                                Text("Color")
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.textSecondary)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: NP.Spacing.md) {
                                        ForEach(availableColors, id: \.self) { color in
                                            Circle()
                                                .fill(Color(hex: color))
                                                .frame(width: 44, height: 44)
                                                .overlay(
                                                    Circle()
                                                        .strokeBorder(NP.Colors.primary, lineWidth: 3)
                                                        .opacity(selectedColor == color ? 1 : 0)
                                                )
                                                .onTapGesture {
                                                    selectedColor = color
                                                }
                                        }
                                    }
                                }
                            }

                            // Icon Picker
                            VStack(alignment: .leading, spacing: NP.Spacing.md) {
                                Text("Icon")
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.textSecondary)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: NP.Spacing.md) {
                                        ForEach(availableIcons, id: \.self) { icon in
                                            Image(systemName: icon)
                                                .font(NP.Typography.IconSize.md)
                                                .foregroundColor(selectedIcon == icon ? NP.Colors.primary : NP.Colors.textSecondary)
                                                .frame(width: 44, height: 44)
                                                .background(
                                                    RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous)
                                                        .fill(selectedIcon == icon ? NP.Colors.lightPurple : NP.Colors.surface)
                                                )
                                                .shadow(color: NP.Shadow.cardColor, radius: 4, x: 0, y: 2)
                                                .onTapGesture {
                                                    selectedIcon = icon
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.xl)

                        // Cards Section
                        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                            HStack {
                                Text("Cards")
                                    .font(NP.Typography.title2)
                                    .foregroundColor(NP.Colors.textBlack)

                                Spacer()

                                Text("\(cards.count)")
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.textSecondary)
                            }

                            ForEach(cards.indices, id: \.self) { index in
                                CardInputView(
                                    card: $cards[index],
                                    index: index + 1,
                                    onDelete: {
                                        withAnimation {
                                            cards.remove(at: index)
                                        }
                                    }
                                )
                            }

                            // Add Card Button
                            Button {
                                withAnimation {
                                    cards.append(CardDraft())
                                }
                            } label: {
                                HStack(spacing: NP.Spacing.md) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color(hex: selectedColor))

                                    Text("Add Card")
                                        .font(NP.Typography.bodySemibold)
                                        .foregroundColor(NP.Colors.textPrimary)

                                    Spacer()
                                }
                                .padding(NP.Spacing.xl)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                                .shadow(color: NP.Shadow.cardColor, radius: 8, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Create Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(NP.Colors.primary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDeck()
                    }
                    .foregroundColor(NP.Colors.primary)
                    .disabled(!canSave)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }

    private var canSave: Bool {
        !deckName.isEmpty && cards.filter { !$0.front.isEmpty && !$0.back.isEmpty }.count >= 2
    }

    private func saveDeck() {
        let deck = Deck(
            name: deckName,
            description: deckDescription,
            colorHex: selectedColor,
            icon: selectedIcon
        )
        modelContext.insert(deck)

        // Create flashcards
        for card in cards where !card.front.isEmpty && !card.back.isEmpty {
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
            showError = true
            errorMessage = "Failed to save deck: \(error.localizedDescription)"
        }
    }
}

// MARK: - Card Draft Model

struct CardDraft: Identifiable {
    let id = UUID()
    var front = ""
    var back = ""
}

// MARK: - Card Input View

struct CardInputView: View {
    @Binding var card: CardDraft
    let index: Int
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: NP.Spacing.md) {
            HStack {
                Text("Card \(index)")
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textBlack)

                Spacer()

                if index > 2 {
                    Button {
                        onDelete()
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(Color(hex: "#FF453A"))
                    }
                }
            }

            TextField("Front (question)", text: $card.front, axis: .vertical)
                .font(NP.Typography.body)
                .foregroundColor(NP.Colors.textPrimary)
                .padding(NP.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous)
                        .fill(NP.Colors.background)
                )
                .lineLimit(3...5)

            TextField("Back (answer)", text: $card.back, axis: .vertical)
                .font(NP.Typography.body)
                .foregroundColor(NP.Colors.textPrimary)
                .padding(NP.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous)
                        .fill(NP.Colors.background)
                )
                .lineLimit(3...5)
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .shadow(color: NP.Shadow.cardColor, radius: 8, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    ManualCreateView()
}
