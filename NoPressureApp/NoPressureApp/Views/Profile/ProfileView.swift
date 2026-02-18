import SwiftUI
import SwiftData
import FabrikaAnalytics

/// Profile screen — matches Figma "Profile Placeholder" (node 2:788)
/// Shows statistics cards + finished decks list
struct ProfileView: View {
    @Query private var decks: [Deck]
    @Query private var users: [User]
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    private var userName: String {
        users.first?.name ?? "Friend"
    }

    @State private var showingSettings = false

    /// Decks that have been fully studied (all cards reviewed at least once)
    private var finishedDecks: [Deck] {
        decks.filter { $0.lastStudied != nil }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Header
                        profileHeader
                            .padding(.top, NP.Spacing.md)

                        // Statistics Cards
                        statisticsSection

                        // Finished Decks
                        finishedDecksSection

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                analytics.trackScreen("Profile", context: modelContext)
            }
        }
    }

    // MARK: - Header

    private var profileHeader: some View {
        HStack(spacing: NP.Spacing.lg) {
            // Avatar circle
            ZStack {
                Circle()
                    .fill(NP.Colors.lightPurple)
                    .frame(width: NP.Size.avatarSize, height: NP.Size.avatarSize)

                Text(String(userName.prefix(1)).uppercased())
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.primary)
            }

            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(userName)
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text("\(decks.count) decks")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            Spacer()

            // Settings button
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(NP.Typography.IconSize.lg)
                    .foregroundColor(NP.Colors.textSecondary)
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
        .sheet(isPresented: $showingSettings) {
            AppSettingsView()
        }
    }

    private var currentStreak: Int {
        var streak = 0
        var checkDate = Calendar.current.startOfDay(for: Date())
        let allCards = decks.flatMap { $0.cards }

        while true {
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: checkDate)!
            let hasActivity = allCards.contains { card in
                guard let lastReview = card.fsrsData?.lastReview else { return false }
                return lastReview >= checkDate && lastReview < nextDay
            }

            if hasActivity {
                streak += 1
                guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else if streak == 0 {
                guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else {
                break
            }
        }
        return streak
    }

    private var totalStudied: Int {
        decks.reduce(0) { total, deck in
            total + deck.cards.filter { $0.fsrsData?.reps ?? 0 > 0 }.count
        }
    }

    // MARK: - Statistics Cards (from Figma: Current Streak, Cards Learned)

    private var statisticsSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            HStack {
                Text("Statistics")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Spacer()

                NavigationLink {
                    StatisticsDetailView()
                } label: {
                    HStack(spacing: NP.Spacing.xs) {
                        Text("See All")
                            .font(NP.Typography.subheadlineSemibold)
                        Image(systemName: "chevron.right")
                            .font(NP.Typography.caption1)
                    }
                    .foregroundColor(NP.Colors.primary)
                }
            }
            .padding(.horizontal, NP.Spacing.xxl)

            HStack(spacing: NP.Spacing.md) {
                StatCard(
                    title: "Current Streak",
                    value: "\(currentStreak)",
                    unit: "days",
                    iconName: "flame.fill",
                    iconColor: NP.Colors.accent
                )

                StatCard(
                    title: "Cards Learned",
                    value: "\(totalStudied)",
                    unit: "total",
                    iconName: "brain.head.profile",
                    iconColor: NP.Colors.primary
                )
            }
            .padding(.horizontal, NP.Spacing.xxl)
        }
    }

    // MARK: - Finished Decks

    private var finishedDecksSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Finished Decks")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)
                .padding(.horizontal, NP.Spacing.xxl)

            if finishedDecks.isEmpty {
                VStack(spacing: NP.Spacing.md) {
                    Image("solar-check-circle-linear")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text("No finished decks yet")
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, NP.Spacing.xxxl)
            } else {
                VStack(spacing: NP.Spacing.md) {
                    ForEach(finishedDecks) { deck in
                        FinishedDeckRow(deck: deck)
                    }
                }
                .padding(.horizontal, NP.Spacing.xxl)
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let iconName: String
    let iconColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            // Icon (matches Figma stat card style)
            HStack(spacing: NP.Spacing.sm) {
                Image("solar-compass-bold")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(iconColor)

                Text(title.uppercased())
                    .font(NP.Typography.caption2Semibold)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            // Value + unit (from Figma: "12 days", "1,832")
            HStack(alignment: .firstTextBaseline, spacing: NP.Spacing.sm) {
                Text(value)
                    .font(NP.Typography.statValue)
                    .foregroundColor(NP.Colors.textBlack)

                Text(unit)
                    .font(NP.Typography.body)
                    .foregroundColor(NP.Colors.textSecondary)
            }
        }
        .padding(NP.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}

// MARK: - Finished Deck Row

struct FinishedDeckRow: View {
    let deck: Deck

    var body: some View {
        HStack(spacing: NP.Spacing.md) {
            Image(systemName: deck.icon)
                .font(NP.Typography.IconSize.md)
                .foregroundColor(NP.Colors.primary)
                .frame(width: 40, height: 40)
                .background(NP.Colors.lightPurple)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(deck.name)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)

                Text("\(deck.cards.count) cards")
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            Spacer()

            Image("solar-check-circle-bold")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(NP.Colors.success)
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}
