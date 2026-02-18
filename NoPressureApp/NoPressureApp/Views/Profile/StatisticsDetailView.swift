import SwiftUI
import SwiftData

struct StatisticsDetailView: View {
    @Query private var decks: [Deck]
    @Environment(\.dismiss) private var dismiss

    private var totalCards: Int {
        decks.reduce(0) { $0 + $1.cards.count }
    }

    private var totalStudied: Int {
        decks.reduce(0) { total, deck in
            total + deck.cards.filter { $0.fsrsData?.reps ?? 0 > 0 }.count
        }
    }

    private var totalMastered: Int {
        decks.reduce(0) { total, deck in
            total + deck.cards.filter { card in
                guard let data = card.fsrsData else { return false }
                return data.reps >= 3 && data.stability > 10
            }.count
        }
    }

    private var accuracyRate: Double {
        let studied = decks.flatMap { $0.cards }.filter { $0.fsrsData?.reps ?? 0 > 0 }
        guard !studied.isEmpty else { return 0 }
        let successful = studied.filter { ($0.fsrsData?.lapses ?? 0) == 0 }.count
        return Double(successful) / Double(studied.count)
    }

    private var currentStreak: Int {
        // Calculate streak from consecutive days with study activity
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
                // Check yesterday if today hasn't been studied yet
                guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) else { break }
                checkDate = previousDay
            } else {
                break
            }
        }

        return streak
    }

    var body: some View {
        ZStack {
            MeshBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: NP.Spacing.xxl) {
                    // Overview Stats
                    overviewSection

                    // Weekly Activity (calendar heatmap simplified)
                    weeklyActivitySection

                    // Per-deck breakdown
                    deckBreakdownSection

                    Spacer(minLength: 60)
                }
                .padding(.top, NP.Spacing.lg)
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Overview

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Overview")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NP.Spacing.md) {
                OverviewStatCard(title: "Current Streak", value: "\(currentStreak)", unit: "days", icon: "flame.fill", color: NP.Colors.accent)
                OverviewStatCard(title: "Cards Studied", value: "\(totalStudied)", unit: "total", icon: "brain.head.profile", color: NP.Colors.primary)
                OverviewStatCard(title: "Mastered", value: "\(totalMastered)", unit: "cards", icon: "star.fill", color: NP.Colors.success)
                OverviewStatCard(title: "Accuracy", value: "\(Int(accuracyRate * 100))%", unit: "", icon: "target", color: NP.Colors.primary)
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Weekly Activity

    private var weeklyActivitySection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Last 7 Days")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)

            HStack(spacing: NP.Spacing.sm) {
                ForEach(0..<7, id: \.self) { dayOffset in
                    let date = Calendar.current.date(byAdding: .day, value: -(6 - dayOffset), to: Date())!
                    let count = cardsStudiedOn(date)
                    VStack(spacing: NP.Spacing.xs) {
                        RoundedRectangle(cornerRadius: NP.Radius.sm)
                            .fill(activityColor(count: count))
                            .frame(height: max(20, CGFloat(min(count * 8, 80))))
                            .frame(maxWidth: .infinity)

                        Text(dayLabel(date))
                            .font(NP.Typography.caption2)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                }
            }
            .padding(NP.Spacing.lg)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Deck Breakdown

    private var deckBreakdownSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
            Text("Per Deck")
                .font(NP.Typography.title2)
                .foregroundColor(NP.Colors.textBlack)

            if decks.isEmpty {
                Text("No decks yet")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
                    .padding(.vertical, NP.Spacing.xl)
            } else {
                ForEach(decks) { deck in
                    DeckStatRow(deck: deck)
                }
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Helpers

    private func cardsStudiedOn(_ date: Date) -> Int {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        return decks.flatMap { $0.cards }.filter { card in
            guard let lastReview = card.fsrsData?.lastReview else { return false }
            return lastReview >= start && lastReview < end
        }.count
    }

    private func activityColor(count: Int) -> Color {
        if count == 0 { return NP.Colors.lightPurple.opacity(0.3) }
        if count < 5 { return NP.Colors.primary.opacity(0.4) }
        if count < 15 { return NP.Colors.primary.opacity(0.7) }
        return NP.Colors.primary
    }

    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(2))
    }
}

// MARK: - Overview Stat Card

struct OverviewStatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Image(systemName: icon)
                .font(NP.Typography.IconSize.md)
                .foregroundColor(color)

            HStack(alignment: .firstTextBaseline, spacing: NP.Spacing.xs) {
                Text(value)
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                if !unit.isEmpty {
                    Text(unit)
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)
                }
            }

            Text(title)
                .font(NP.Typography.caption1)
                .foregroundColor(NP.Colors.textSecondary)
        }
        .padding(NP.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}

// MARK: - Deck Stat Row

struct DeckStatRow: View {
    let deck: Deck

    private var masteredCount: Int {
        deck.cards.filter { card in
            guard let data = card.fsrsData else { return false }
            return data.reps >= 3 && data.stability > 10
        }.count
    }

    private var progress: Double {
        guard !deck.cards.isEmpty else { return 0 }
        return Double(masteredCount) / Double(deck.cards.count)
    }

    var body: some View {
        HStack(spacing: NP.Spacing.md) {
            Image(systemName: deck.icon)
                .font(NP.Typography.IconSize.md)
                .foregroundColor(Color(hex: deck.colorHex))
                .frame(width: 40, height: 40)
                .background(Color(hex: deck.colorHex).opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))

            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(deck.name)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)

                HStack(spacing: NP.Spacing.sm) {
                    Text("\(deck.cards.count) cards")
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text("\(masteredCount) mastered")
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.success)
                }
            }

            Spacer()

            // Mini progress ring
            ZStack {
                Circle()
                    .stroke(NP.Colors.lightPurple, lineWidth: 3)
                    .frame(width: 32, height: 32)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(NP.Colors.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(progress * 100))%")
                    .font(NP.Typography.caption2)
                    .foregroundColor(NP.Colors.textSecondary)
            }
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}
