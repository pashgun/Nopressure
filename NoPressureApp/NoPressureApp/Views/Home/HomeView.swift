import SwiftUI
import SwiftData
import FabrikaAnalytics

struct HomeView: View {
    @Query private var decks: [Deck]
    @Query private var users: [User]
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    @State private var selectedStudyDeck: Deck?
    @State private var navigationPath = NavigationPath()
    @State private var deckToDelete: Deck?
    @State private var showDeleteDeckConfirmation = false
    @State private var deckToEdit: Deck?

    private var userName: String {
        users.first?.name ?? "Friend"
    }

    private var dailyProgress: Double {
        guard let deck = decks.first else { return 0 }
        let totalCards = deck.cards.count
        guard totalCards > 0 else { return 0 }
        let reviewedToday = deck.cards.filter { card in
            guard let lastReview = card.fsrsData?.lastReview else { return false }
            return Calendar.current.isDateInToday(lastReview)
        }.count
        return Swift.min(Double(reviewedToday) / Double(totalCards), 1.0)
    }

    private var cardsLeft: Int {
        guard let deck = decks.first else { return 0 }
        return deck.cards.filter { card in
            guard let nextReview = card.fsrsData?.nextReview else { return true }
            return nextReview <= Date()
        }.count
    }

    private var currentDeckName: String {
        decks.first?.name ?? "No Decks"
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NP.Spacing.xxl) {
                        // MARK: - Header: Date + Greeting
                        headerSection
                            .padding(.top, NP.Spacing.md)

                        // MARK: - Hero Card (illustration + progress + CTA)
                        heroCard

                        // MARK: - My Decks Section
                        myDecksSection

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Deck.self) { deck in
                DeckDetailView(deck: deck)
            }
            .fullScreenCover(item: $selectedStudyDeck) { deck in
                StudySessionView(deck: deck)
            }
            .onAppear {
                analytics.trackScreen("Home", context: modelContext)
            }
            .sheet(item: $deckToEdit) { deck in
                DeckSettingsView(deck: deck)
            }
            .alert("Delete Deck", isPresented: $showDeleteDeckConfirmation) {
                Button("Cancel", role: .cancel) {
                    deckToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let deck = deckToDelete {
                        modelContext.delete(deck)
                        try? modelContext.save()
                        deckToDelete = nil
                    }
                }
            } message: {
                if let deck = deckToDelete {
                    Text("Are you sure you want to delete \"\(deck.name)\"? This will also delete all \(deck.cards.count) cards. This action cannot be undone.")
                }
            }
        }
    }

    private func confirmDeleteDeck(_ deck: Deck) {
        deckToDelete = deck
        showDeleteDeckConfirmation = true
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(formattedDate().uppercased())
                    .font(NP.Typography.overline)
                    .foregroundColor(NP.Colors.textSecondary)
                    .tracking(1.2)

                Text("Hi, \(userName)")
                    .font(NP.Typography.largeTitle)
                    .foregroundColor(NP.Colors.textBlack)
            }

            Spacer()

            // Progress ring — in header, top right (per Figma)
            progressRing
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        VStack(spacing: 0) {
            // Top area: illustration
            ZStack {
                // Orange blob background area
                RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous)
                    .fill(NP.Colors.lightOrange)
                    .frame(height: 200)

                // Hero illustration from Figma
                Image("hero-books")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .clipped()
            }
            .frame(height: 200)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: NP.Radius.lg,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: NP.Radius.lg
                )
            )

            // Bottom area: tags + deck name + CTA button
            VStack(alignment: .leading, spacing: NP.Spacing.md) {
                // Tags row
                HStack(spacing: NP.Spacing.sm) {
                    TagPill(text: "DAILY GOAL", color: NP.Colors.accent, textColor: .white)
                    TagPill(text: "\(cardsLeft) LEFT", color: NP.Colors.lightPurple, textColor: NP.Colors.primary)
                }
                .padding(.top, NP.Spacing.lg)

                // Deck name
                Text(currentDeckName)
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                // Continue Learning button
                Button {
                    selectedStudyDeck = decks.first
                } label: {
                    Text("Continue Learning")
                        .npPrimaryButton()
                }
                .disabled(decks.isEmpty)
                .opacity(decks.isEmpty ? 0.5 : 1.0)
                .padding(.top, NP.Spacing.sm)
            }
            .padding(.horizontal, NP.Spacing.lg)
            .padding(.bottom, NP.Spacing.lg)
        }
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
        .npCardShadow()
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Progress Ring (from Figma: 87% shown)

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.4), lineWidth: 5)
                .frame(width: 64, height: 64)

            Circle()
                .trim(from: 0, to: dailyProgress)
                .stroke(
                    NP.Colors.accent,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: 64, height: 64)
                .rotationEffect(.degrees(-90))

            Text("\(Int(dailyProgress * 100))%")
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.textBlack)
        }
        .padding(NP.Spacing.sm)
        .background(Color.white.opacity(0.6))
        .clipShape(Circle())
    }

    // MARK: - My Decks

    private var myDecksSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("My Decks")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)
                .padding(.horizontal, NP.Spacing.xxl)

            if decks.isEmpty {
                // Empty state
                VStack(spacing: NP.Spacing.lg) {
                    Image("solar-deck")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(NP.Colors.primary)

                    Text("No decks yet")
                        .font(NP.Typography.title3)
                        .foregroundColor(NP.Colors.textPrimary)

                    Text("Create your first deck to start learning")
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, NP.Spacing.xxxl)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: NP.Spacing.md) {
                        ForEach(decks.prefix(5)) { deck in
                            Button {
                                navigationPath.append(deck)
                            } label: {
                                DeckCardView(deck: deck)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    navigationPath.append(deck)
                                } label: {
                                    Label("Open", systemImage: "folder")
                                }

                                Button {
                                    deckToEdit = deck
                                } label: {
                                    Label("Edit Deck", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    confirmDeleteDeck(deck)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)
                }
            }
        }
    }

    // MARK: - Helpers

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - Tag Pill

struct TagPill: View {
    let text: String
    let color: Color
    var textColor: Color = .white

    var body: some View {
        Text(text)
            .font(NP.Typography.caption2Semibold)
            .foregroundColor(textColor)
            .padding(.horizontal, NP.Spacing.md)
            .padding(.vertical, NP.Spacing.xs)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Deck Card (horizontal scroll)

struct DeckCardView: View {
    let deck: Deck

    var body: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.sm) {
            HStack {
                // Card count + rating (from Figma)
                HStack(spacing: NP.Spacing.sm) {
                    Image("solar-deck")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text("\(deck.cards.count)")
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)
                }

                Spacer()

                // Check circle for completed decks (matches Figma)
                Image("solar-check-circle-bold")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .foregroundColor(NP.Colors.primary)
            }

            Spacer()

            // Deck name
            Text(deck.name)
                .font(NP.Typography.bodySemibold)
                .foregroundColor(NP.Colors.textPrimary)
                .lineLimit(2)
        }
        .padding(NP.Spacing.lg)
        .frame(width: 160, height: 140)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}
