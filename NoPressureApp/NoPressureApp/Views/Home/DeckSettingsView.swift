import SwiftUI
import SwiftData

struct DeckSettingsView: View {
    @Bindable var deck: Deck
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var deckName: String = ""
    @State private var deckDescription: String = ""
    @State private var selectedColor: String = ""
    @State private var selectedIcon: String = ""
    @State private var showDeleteConfirmation = false

    private let colorOptions = [
        "#5533FF", "#FF375F", "#FF9F0A", "#30D158",
        "#0A84FF", "#BF5AF2", "#FF6482", "#32ADE6"
    ]

    private let iconOptions = [
        "folder.fill", "book.fill", "star.fill", "globe",
        "brain.head.profile", "lightbulb.fill", "flag.fill", "heart.fill",
        "graduationcap.fill", "atom", "function", "music.note"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Deck Name
                        inputSection(title: "Deck Name") {
                            TextField("Enter deck name", text: $deckName)
                                .font(NP.Typography.body)
                                .foregroundColor(NP.Colors.textPrimary)
                                .padding(NP.Spacing.lg)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                                .npSubtleShadow()
                        }

                        // Description
                        inputSection(title: "Description") {
                            TextField("Optional description", text: $deckDescription, axis: .vertical)
                                .font(NP.Typography.body)
                                .foregroundColor(NP.Colors.textPrimary)
                                .lineLimit(3...6)
                                .padding(NP.Spacing.lg)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                                .npSubtleShadow()
                        }

                        // Color Picker
                        inputSection(title: "Color") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: NP.Spacing.md) {
                                ForEach(colorOptions, id: \.self) { hex in
                                    Circle()
                                        .fill(Color(hex: hex))
                                        .frame(width: 36, height: 36)
                                        .overlay {
                                            if selectedColor == hex {
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                                    .frame(width: 28, height: 28)
                                            }
                                        }
                                        .onTapGesture {
                                            selectedColor = hex
                                        }
                                }
                            }
                        }

                        // Icon Picker
                        inputSection(title: "Icon") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: NP.Spacing.md) {
                                ForEach(iconOptions, id: \.self) { icon in
                                    Image(systemName: icon)
                                        .font(NP.Typography.IconSize.lg)
                                        .foregroundColor(selectedIcon == icon ? .white : NP.Colors.textSecondary)
                                        .frame(width: 44, height: 44)
                                        .background(selectedIcon == icon ? NP.Colors.primary : NP.Colors.surface)
                                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                                        .npSubtleShadow()
                                        .onTapGesture {
                                            selectedIcon = icon
                                        }
                                }
                            }
                        }

                        // Delete Button
                        Button(role: .destructive) {
                            showDeleteConfirmation = true
                        } label: {
                            Text("Delete Deck")
                                .font(NP.Typography.subheadlineSemibold)
                                .foregroundColor(NP.Colors.error)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, NP.Spacing.lg)
                        }
                        .padding(.top, NP.Spacing.xl)

                        Spacer(minLength: 60)
                    }
                    .padding(.top, NP.Spacing.lg)
                }
            }
            .navigationTitle("Deck Settings")
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
                        dismiss()
                    }
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.primary)
                    .disabled(deckName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Delete Deck", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    modelContext.delete(deck)
                    try? modelContext.save()
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete \"\(deck.name)\"? This will also delete all \(deck.cards.count) cards.")
            }
        }
        .onAppear {
            deckName = deck.name
            deckDescription = deck.deckDescription
            selectedColor = deck.colorHex
            selectedIcon = deck.icon
        }
    }

    private func inputSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text(title)
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.textBlack)

            content()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    private func saveDeck() {
        deck.name = deckName.trimmingCharacters(in: .whitespaces)
        deck.deckDescription = deckDescription.trimmingCharacters(in: .whitespaces)
        deck.colorHex = selectedColor
        deck.icon = selectedIcon
        try? modelContext.save()
    }
}
