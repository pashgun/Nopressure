import SwiftUI
import SwiftData

struct CardEditView: View {
    let deck: Deck
    let card: Flashcard?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var frontText = ""
    @State private var backText = ""
    @State private var showingPreview = false

    private var isEditing: Bool { card != nil }
    private var isValid: Bool {
        !frontText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !backText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Front Side
                        cardInputSection(
                            title: "Front Side",
                            placeholder: "Enter the question or term...",
                            text: $frontText
                        )

                        // Back Side
                        cardInputSection(
                            title: "Back Side",
                            placeholder: "Enter the answer or definition...",
                            text: $backText
                        )

                        // Preview
                        if showingPreview && isValid {
                            previewSection
                        }

                        // Preview Toggle
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showingPreview.toggle()
                            }
                        } label: {
                            HStack(spacing: NP.Spacing.sm) {
                                Image(systemName: showingPreview ? "eye.slash" : "eye")
                                Text(showingPreview ? "Hide Preview" : "Show Preview")
                            }
                            .font(NP.Typography.subheadlineSemibold)
                            .foregroundColor(NP.Colors.primary)
                        }
                        .disabled(!isValid)
                        .opacity(isValid ? 1.0 : 0.5)

                        Spacer(minLength: 60)
                    }
                    .padding(.top, NP.Spacing.lg)
                }
            }
            .navigationTitle(isEditing ? "Edit Card" : "New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(NP.Colors.primary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Add") {
                        saveCard()
                        dismiss()
                    }
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.primary)
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            if let card = card {
                frontText = card.front
                backText = card.back
            }
        }
    }

    // MARK: - Card Input Section

    private func cardInputSection(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text(title)
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.textBlack)

            TextEditor(text: text)
                .font(NP.Typography.body)
                .foregroundColor(NP.Colors.textPrimary)
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
                .padding(NP.Spacing.lg)
                .background(NP.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                .npSubtleShadow()
                .overlay(alignment: .topLeading) {
                    if text.wrappedValue.isEmpty {
                        Text(placeholder)
                            .font(NP.Typography.body)
                            .foregroundColor(NP.Colors.textSecondary)
                            .padding(NP.Spacing.lg)
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
                }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Preview

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text("Preview")
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.textBlack)

            VStack(spacing: NP.Spacing.md) {
                // Front
                VStack(spacing: NP.Spacing.sm) {
                    Text("FRONT")
                        .font(NP.Typography.caption2Semibold)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text(frontText)
                        .font(NP.Typography.title3)
                        .foregroundColor(NP.Colors.textBlack)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(NP.Spacing.xl)
                .background(NP.Colors.lightPurple.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))

                Image(systemName: "arrow.down")
                    .foregroundColor(NP.Colors.textSecondary)

                // Back
                VStack(spacing: NP.Spacing.sm) {
                    Text("BACK")
                        .font(NP.Typography.caption2Semibold)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text(backText)
                        .font(NP.Typography.body)
                        .foregroundColor(NP.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(NP.Spacing.xl)
                .background(NP.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                .npSubtleShadow()
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Save

    private func saveCard() {
        let front = frontText.trimmingCharacters(in: .whitespaces)
        let back = backText.trimmingCharacters(in: .whitespaces)

        if let card = card {
            card.front = front
            card.back = back
        } else {
            let newCard = Flashcard(front: front, back: back, deck: deck)
            modelContext.insert(newCard)
        }
        try? modelContext.save()
    }
}
