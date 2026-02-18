import SwiftUI
import SwiftData
import FabrikaAnalytics

/// Profile screen — matches Figma "Profile Placeholder" (node 2:788)
/// Shows date, daily goal, statistics cards, weekly chart, finished decks
struct ProfileView: View {
    @Query private var decks: [Deck]
    @Query private var users: [User]
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext

    private var userName: String {
        users.first?.name ?? "Friend"
    }

    private var dailyGoalCards: Int {
        users.first?.dailyMinutes ?? 15
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
                        // Date
                        dateSection
                            .padding(.top, NP.Spacing.sm)

                        // Header
                        profileHeader

                        // Daily Goal
                        dailyGoalSection

                        // Statistics Cards
                        statisticsSection

                        // Weekly Activity Chart
                        weeklyChartSection

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

    // MARK: - Date Section

    private var dateSection: some View {
        HStack {
            Text(Date(), format: .dateTime.weekday(.wide).month(.wide).day())
                .font(NP.Typography.subheadline)
                .foregroundColor(NP.Colors.textSecondary)

            Spacer()
        }
        .padding(.horizontal, NP.Spacing.xxl)
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

    // MARK: - Daily Goal

    private var cardsStudiedToday: Int {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        return decks.flatMap { $0.cards }.filter { card in
            guard let lastReview = card.fsrsData?.lastReview else { return false }
            return lastReview >= startOfDay && lastReview < endOfDay
        }.count
    }

    private var dailyGoalProgress: Double {
        guard dailyGoalCards > 0 else { return 0 }
        return min(Double(cardsStudiedToday) / Double(dailyGoalCards), 1.0)
    }

    private var dailyGoalSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Daily Goal")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)

            HStack(spacing: NP.Spacing.xxl) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(NP.Colors.lightPurple, lineWidth: 8)
                        .frame(width: 80, height: 80)

                    Circle()
                        .trim(from: 0, to: dailyGoalProgress)
                        .stroke(
                            dailyGoalProgress >= 1.0 ? NP.Colors.success : NP.Colors.primary,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: dailyGoalProgress)

                    VStack(spacing: 2) {
                        Text("\(Int(dailyGoalProgress * 100))%")
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(NP.Colors.textBlack)
                    }
                }

                VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                    Text("\(cardsStudiedToday) / \(dailyGoalCards) cards")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(NP.Colors.textBlack)

                    Text(cardsStudiedToday >= dailyGoalCards
                         ? "Goal completed! 🎉"
                         : "\(dailyGoalCards - cardsStudiedToday) cards to go")
                        .font(NP.Typography.subheadline)
                        .foregroundColor(cardsStudiedToday >= dailyGoalCards ? NP.Colors.success : NP.Colors.textSecondary)
                }

                Spacer()
            }
            .padding(NP.Spacing.xl)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Streak & Cards Learned

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

    // MARK: - Weekly Activity Chart

    private var weeklyChartSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Last 7 Days")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)

            VStack(spacing: NP.Spacing.md) {
                HStack(alignment: .bottom, spacing: NP.Spacing.sm) {
                    ForEach(0..<7, id: \.self) { dayOffset in
                        let date = Calendar.current.date(byAdding: .day, value: -(6 - dayOffset), to: Date())!
                        let count = cardsStudiedOn(date)
                        let maxCount = maxCardsInWeek

                        VStack(spacing: NP.Spacing.xs) {
                            // Count label
                            if count > 0 {
                                Text("\(count)")
                                    .font(NP.Typography.caption2)
                                    .foregroundColor(NP.Colors.textSecondary)
                            }

                            // Bar
                            RoundedRectangle(cornerRadius: NP.Radius.sm)
                                .fill(barColor(count: count, dayOffset: dayOffset))
                                .frame(height: barHeight(count: count, maxCount: maxCount))
                                .frame(maxWidth: .infinity)

                            // Day label
                            Text(dayLabel(date))
                                .font(NP.Typography.caption2)
                                .foregroundColor(isToday(date) ? NP.Colors.primary : NP.Colors.textSecondary)
                                .fontWeight(isToday(date) ? .bold : .regular)
                        }
                    }
                }
                .frame(height: 120)
                .padding(.top, NP.Spacing.sm)
            }
            .padding(NP.Spacing.lg)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
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

    // MARK: - Chart Helpers

    private func cardsStudiedOn(_ date: Date) -> Int {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        return decks.flatMap { $0.cards }.filter { card in
            guard let lastReview = card.fsrsData?.lastReview else { return false }
            return lastReview >= start && lastReview < end
        }.count
    }

    private var maxCardsInWeek: Int {
        (0..<7).map { dayOffset in
            let date = Calendar.current.date(byAdding: .day, value: -(6 - dayOffset), to: Date())!
            return cardsStudiedOn(date)
        }.max() ?? 1
    }

    private func barHeight(count: Int, maxCount: Int) -> CGFloat {
        let minHeight: CGFloat = 8
        let maxHeight: CGFloat = 80
        guard maxCount > 0 else { return minHeight }
        if count == 0 { return minHeight }
        return minHeight + (maxHeight - minHeight) * CGFloat(count) / CGFloat(maxCount)
    }

    private func barColor(count: Int, dayOffset: Int) -> Color {
        if count == 0 { return NP.Colors.lightPurple.opacity(0.4) }
        let isLast = dayOffset == 6
        if isLast { return NP.Colors.primary }
        if count < 5 { return NP.Colors.primary.opacity(0.5) }
        if count < 15 { return NP.Colors.primary.opacity(0.7) }
        return NP.Colors.primary.opacity(0.85)
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(2))
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
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
