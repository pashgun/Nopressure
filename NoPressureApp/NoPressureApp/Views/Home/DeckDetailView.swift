import SwiftUI
import SwiftData

struct DeckDetailView: View {
    let deck: Deck
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var showingStudy = false
    @State private var showingSettings = false
    @State private var showDeleteConfirmation = false
    @State private var showingAddCard = false

    var dueCards: [Flashcard] {
        deck.cards.filter { card in
            guard let nextReview = card.fsrsData?.nextReview else { return true }
            return nextReview <= Date()
        }
    }

    var newCards: [Flashcard] {
        deck.cards.filter { $0.fsrsData?.reps == 0 || $0.fsrsData == nil }
    }

    var masteredCards: [Flashcard] {
        deck.cards.filter { card in
            guard let data = card.fsrsData else { return false }
            return data.reps >= 3 && data.stability > 10
        }
    }

    var progressPercent: Double {
        guard !deck.cards.isEmpty else { return 0 }
        return Double(masteredCards.count) / Double(deck.cards.count)
    }

    var body: some View {
        ZStack {
            MeshBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: NP.Spacing.xxl) {
                    headerSection
                    progressSection
                    statsSection
                    cardsPreviewSection
                    actionButtons
                    dangerZone
                    Spacer(minLength: 60)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Edit Deck", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete Deck", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(NP.Colors.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $showingStudy) {
            StudySessionView(deck: deck)
        }
        .sheet(isPresented: $showingSettings) {
            DeckSettingsView(deck: deck)
        }
        .sheet(isPresented: $showingAddCard) {
            CardEditView(deck: deck, card: nil)
        }
        .alert("Delete Deck", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                modelContext.delete(deck)
                try? modelContext.save()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(deck.name)\"? This will also delete all \(deck.cards.count) cards. This action cannot be undone.")
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: NP.Spacing.lg) {
            ZStack {
                Circle()
                    .fill(Color(hex: deck.colorHex).opacity(0.15))
                    .frame(width: 80, height: 80)

                Image(systemName: deck.icon)
                    .font(NP.Typography.IconSize.xl)
                    .foregroundColor(Color(hex: deck.colorHex))
            }

            VStack(spacing: NP.Spacing.sm) {
                Text(deck.name)
                    .font(NP.Typography.title1)
                    .foregroundColor(NP.Colors.textBlack)
                    .multilineTextAlignment(.center)

                if !deck.deckDescription.isEmpty {
                    Text(deck.deckDescription)
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let lastStudied = deck.lastStudied {
                Text("Last studied \(lastStudied, style: .relative) ago")
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
            }
        }
        .padding(.top, NP.Spacing.xl)
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Progress Ring

    private var progressSection: some View {
        VStack(spacing: NP.Spacing.md) {
            ZStack {
                Circle()
                    .stroke(NP.Colors.lightPurple, lineWidth: 8)
                    .frame(width: 100, height: 100)

                Circle()
                    .trim(from: 0, to: progressPercent)
                    .stroke(
                        NP.Colors.primary,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(progressPercent * 100))%")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)
            }

            Text("Mastered")
                .font(NP.Typography.caption1)
                .foregroundColor(NP.Colors.textSecondary)
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: NP.Spacing.lg) {
            StatBox(title: "Total", value: "\(deck.cards.count)", color: NP.Colors.primary)
            StatBox(title: "Due", value: "\(dueCards.count)", color: NP.Colors.accent)
            StatBox(title: "New", value: "\(newCards.count)", color: NP.Colors.success)
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Cards Preview

    private var cardsPreviewSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            HStack {
                Text("Cards")
                    .font(NP.Typography.title3)
                    .foregroundColor(NP.Colors.textBlack)

                Spacer()

                Text("\(deck.cards.count) total")
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            if deck.cards.isEmpty {
                VStack(spacing: NP.Spacing.lg) {
                    Text("No cards yet. Start by adding some cards to this deck.")
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)

                    Button {
                        showingAddCard = true
                    } label: {
                        HStack(spacing: NP.Spacing.md) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(NP.Colors.primary)
                            Text("Add Card")
                                .font(NP.Typography.bodySemibold)
                                .foregroundColor(NP.Colors.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, NP.Spacing.lg)
                        .background(NP.Colors.lightPurple.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                    }
                    .padding(.top, NP.Spacing.sm)
                }
                .padding(.vertical, NP.Spacing.xl)
            } else {
                ForEach(Array(deck.cards.prefix(5))) { card in
                    HStack {
                        Text(card.front)
                            .font(NP.Typography.body)
                            .foregroundColor(NP.Colors.textPrimary)
                            .lineLimit(1)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(NP.Typography.caption1)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                    .padding(NP.Spacing.lg)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                    .npSubtleShadow()
                }

                if deck.cards.count > 5 {
                    Text("+ \(deck.cards.count - 5) more cards")
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: NP.Spacing.md) {
            Button {
                showingStudy = true
            } label: {
                HStack(spacing: NP.Spacing.md) {
                    Image(systemName: "play.fill")
                    Text(dueCards.isEmpty ? "Study All Cards" : "Study Now (\(dueCards.count) due)")
                }
                .npPrimaryButton()
            }
            .disabled(deck.cards.isEmpty)
            .opacity(deck.cards.isEmpty ? 0.5 : 1.0)

            HStack(spacing: NP.Spacing.md) {
                Button {
                    showingAddCard = true
                } label: {
                    HStack(spacing: NP.Spacing.md) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Card")
                    }
                    .npSecondaryButton()
                }

                NavigationLink {
                    CardListView(deck: deck)
                } label: {
                    HStack(spacing: NP.Spacing.md) {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Browse All Cards")
                    }
                    .npSecondaryButton()
                }
            }

            Button {
                showingSettings = true
            } label: {
                HStack(spacing: NP.Spacing.md) {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .npSecondaryButton()
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Danger Zone

    private var dangerZone: some View {
        Button(role: .destructive) {
            showDeleteConfirmation = true
        } label: {
            Text("Delete Deck")
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.error)
        }
        .padding(.top, NP.Spacing.lg)
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: NP.Spacing.sm) {
            Text(value)
                .font(NP.Typography.title2)
                .foregroundColor(color)

            Text(title)
                .font(NP.Typography.caption1)
                .foregroundColor(NP.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}
