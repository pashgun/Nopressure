import SwiftUI

struct CreateView: View {
    /// Called with the created deck after save; parent should dismiss this view and navigate to DeckDetail.
    var onDeckCreated: ((Deck) -> Void)?

    @State private var showingManualCreate = false
    @State private var showingAIGeneration = false
    @State private var showingImportDeck = false

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: NP.Spacing.xxxl) {
                    // Header
                    VStack(spacing: NP.Spacing.sm) {
                        Text("Create Flashcards")
                            .font(NP.Typography.largeTitle)
                            .foregroundColor(NP.Colors.textBlack)

                        Text("Choose how you want to create your deck")
                            .font(NP.Typography.subheadline)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                    .padding(.top, 60)

                    Spacer()

                    // Three equal options
                    VStack(spacing: NP.Spacing.lg) {
                        CreateOptionCard(
                            emoji: "✍️",
                            title: "Manual",
                            subtitle: "Create cards one by one",
                            accentColor: NP.Colors.primary
                        ) {
                            showingManualCreate = true
                        }

                        CreateOptionCard(
                            emoji: "✨",
                            title: "AI Generation",
                            subtitle: "Generate from text, photo, or PDF",
                            accentColor: NP.Colors.accent
                        ) {
                            showingAIGeneration = true
                        }

                        CreateOptionCard(
                            emoji: "📥",
                            title: "Import Deck",
                            subtitle: "Anki, Google Sheets, CSV",
                            accentColor: NP.Colors.success
                        ) {
                            showingImportDeck = true
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    Spacer()
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingManualCreate) {
                ManualCreateView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingManualCreate = false
                })
            }
            .fullScreenCover(isPresented: $showingAIGeneration) {
                AIGenerationView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingAIGeneration = false
                })
            }
            .sheet(isPresented: $showingImportDeck) {
                ImportDeckView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingImportDeck = false
                })
            }
        }
    }
}

// MARK: - Create Option Card

struct CreateOptionCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    var accentColor: Color = NP.Colors.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: NP.Spacing.lg) {
                // Emoji icon in a tinted circle
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 56, height: 56)

                    Text(emoji)
                        .font(.system(size: 28))
                }

                VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                    Text(title)
                        .font(NP.Typography.title3)
                        .foregroundColor(NP.Colors.textPrimary)

                    Text(subtitle)
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(NP.Typography.IconSize.sm)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .padding(NP.Spacing.xxl)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
            .npCardShadow()
        }
    }
}

#Preview {
    CreateView(onDeckCreated: nil)
}
