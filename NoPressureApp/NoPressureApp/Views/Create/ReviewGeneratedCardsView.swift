import SwiftUI

struct ReviewGeneratedCardsView: View {
    @Binding var cards: [GeneratedFlashcard]
    let onSave: (String, String?, String, String) -> Void
    let onCancel: () -> Void

    @State private var deckName = ""
    @State private var deckDescription = ""
    @State private var selectedColor = "#5533FF"
    @State private var selectedIcon = "star.fill"

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
        ZStack {
            MeshBackground()

            ScrollView {
                VStack(spacing: NP.Spacing.xxl) {
                    // Success Header
                    VStack(spacing: NP.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(NP.Colors.lightPurple)
                                .frame(width: 100, height: 100)

                            Image("solar-check-circle-bold")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 56, height: 56)
                                .foregroundColor(NP.Colors.primary)
                        }

                        Text("Generated \(cards.count) flashcards")
                            .font(NP.Typography.title1)
                            .foregroundColor(NP.Colors.textBlack)

                        Text("Review and edit before saving")
                            .font(NP.Typography.subheadline)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                    .padding(.top, 40)

                    // Deck Details
                    VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                        Text("Deck Details")
                            .font(NP.Typography.title2)
                            .foregroundColor(NP.Colors.textBlack)

                        TextField("Deck name", text: $deckName)
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(NP.Colors.textPrimary)
                            .padding(NP.Spacing.lg)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            .npCardShadow()

                        TextField("Description (optional)", text: $deckDescription)
                            .font(NP.Typography.body)
                            .foregroundColor(NP.Colors.textPrimary)
                            .padding(NP.Spacing.lg)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            .npCardShadow()

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
                                            .npSubtleShadow()
                                            .onTapGesture {
                                                selectedIcon = icon
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    // Cards List
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

                        ForEach($cards) { $card in
                            EditableCardView(card: $card)
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    Spacer(minLength: 100)
                }
            }

            // Bottom Buttons
            VStack {
                Spacer()

                HStack(spacing: NP.Spacing.lg) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.error)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                    .npCardShadow()

                    Button("Save Deck") {
                        onSave(
                            deckName.isEmpty ? "New Deck" : deckName,
                            deckDescription.isEmpty ? nil : deckDescription,
                            selectedColor,
                            selectedIcon
                        )
                    }
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(NP.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                    .disabled(cards.isEmpty)
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.bottom, 40)
            }
        }
    }
}

struct EditableCardView: View {
    @Binding var card: GeneratedFlashcard

    var body: some View {
        VStack(spacing: NP.Spacing.md) {
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
        .npCardShadow()
    }
}

#Preview {
    @Previewable @State var cards = [
        GeneratedFlashcard(front: "What is SwiftUI?", back: "A declarative UI framework for Apple platforms"),
        GeneratedFlashcard(front: "What is SwiftData?", back: "Apple's persistence framework introduced in iOS 17")
    ]

    return ReviewGeneratedCardsView(
        cards: $cards,
        onSave: { name, desc, color, icon in
            print("Save: \(name)")
        },
        onCancel: {
            print("Cancel")
        }
    )
}
