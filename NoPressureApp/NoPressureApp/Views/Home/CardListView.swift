import SwiftUI
import SwiftData

struct CardListView: View {
    let deck: Deck
    @Environment(\.modelContext) private var modelContext

    @State private var searchText = ""
    @State private var selectedFilter: CardFilter = .all
    @State private var selectedSort: CardSort = .created
    @State private var showingAddCard = false
    @State private var selectedCard: Flashcard?

    enum CardFilter: String, CaseIterable {
        case all = "All"
        case new = "New"
        case learning = "Learning"
        case review = "Review"
        case mastered = "Mastered"
    }

    enum CardSort: String, CaseIterable {
        case created = "Created"
        case alphabetical = "A-Z"
        case dueDate = "Due Date"
    }

    var filteredCards: [Flashcard] {
        var result = deck.cards

        // Search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.front.localizedCaseInsensitiveContains(searchText) ||
                $0.back.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Status filter
        switch selectedFilter {
        case .all:
            break
        case .new:
            result = result.filter { $0.fsrsData?.reps == 0 || $0.fsrsData == nil }
        case .learning:
            result = result.filter { card in
                guard let data = card.fsrsData else { return false }
                return data.reps > 0 && data.reps < 3
            }
        case .review:
            result = result.filter { card in
                guard let nextReview = card.fsrsData?.nextReview else { return false }
                return nextReview <= Date()
            }
        case .mastered:
            result = result.filter { card in
                guard let data = card.fsrsData else { return false }
                return data.reps >= 3 && data.stability > 10
            }
        }

        // Sort
        switch selectedSort {
        case .created:
            result.sort { $0.createdAt > $1.createdAt }
        case .alphabetical:
            result.sort { $0.front.localizedCompare($1.front) == .orderedAscending }
        case .dueDate:
            result.sort {
                ($0.fsrsData?.nextReview ?? .distantFuture) < ($1.fsrsData?.nextReview ?? .distantFuture)
            }
        }

        return result
    }

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(NP.Colors.textSecondary)

                    TextField("Search cards...", text: $searchText)
                        .foregroundColor(NP.Colors.textPrimary)
                }
                .padding(NP.Spacing.md)
                .background(NP.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                .npSubtleShadow()
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.top, NP.Spacing.md)

                // Filter + Sort Row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: NP.Spacing.sm) {
                        ForEach(CardFilter.allCases, id: \.self) { filter in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedFilter = filter
                                }
                            } label: {
                                Text(filter.rawValue)
                                    .font(NP.Typography.caption2Semibold)
                                    .foregroundColor(selectedFilter == filter ? .white : NP.Colors.textSecondary)
                                    .padding(.horizontal, NP.Spacing.lg)
                                    .padding(.vertical, NP.Spacing.sm)
                                    .background(selectedFilter == filter ? NP.Colors.primary : NP.Colors.surface)
                                    .clipShape(Capsule())
                                    .npSubtleShadow()
                            }
                        }

                        Divider()
                            .frame(height: 20)

                        Menu {
                            ForEach(CardSort.allCases, id: \.self) { sort in
                                Button {
                                    selectedSort = sort
                                } label: {
                                    Label(sort.rawValue, systemImage: selectedSort == sort ? "checkmark" : "")
                                }
                            }
                        } label: {
                            HStack(spacing: NP.Spacing.xs) {
                                Image(systemName: "arrow.up.arrow.down")
                                Text(selectedSort.rawValue)
                            }
                            .font(NP.Typography.caption2Semibold)
                            .foregroundColor(NP.Colors.textSecondary)
                            .padding(.horizontal, NP.Spacing.lg)
                            .padding(.vertical, NP.Spacing.sm)
                            .background(NP.Colors.surface)
                            .clipShape(Capsule())
                            .npSubtleShadow()
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)
                }
                .padding(.top, NP.Spacing.md)

                // Card List
                if filteredCards.isEmpty {
                    Spacer()
                    VStack(spacing: NP.Spacing.lg) {
                        Image(systemName: "rectangle.on.rectangle.slash")
                            .font(NP.Typography.IconSize.xl)
                            .foregroundColor(NP.Colors.textSecondary)

                        Text(searchText.isEmpty ? "No cards yet" : "No matching cards")
                            .font(NP.Typography.title3)
                            .foregroundColor(NP.Colors.textPrimary)

                        if searchText.isEmpty {
                            Text("Add your first card to start learning")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: NP.Spacing.md) {
                            ForEach(filteredCards) { card in
                                Button {
                                    selectedCard = card
                                } label: {
                                    CardListRow(card: card)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        selectedCard = card
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        deleteCard(card)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.md)
                        .padding(.bottom, 80)
                    }
                }
            }
        }
        .navigationTitle("Cards (\(deck.cards.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddCard = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(NP.Colors.primary)
                }
            }
        }
        .sheet(isPresented: $showingAddCard) {
            CardEditView(deck: deck, card: nil)
        }
        .sheet(item: $selectedCard) { card in
            CardEditView(deck: deck, card: card)
        }
    }

    private func deleteCard(_ card: Flashcard) {
        modelContext.delete(card)
        try? modelContext.save()
    }
}

// MARK: - Card List Row

struct CardListRow: View {
    let card: Flashcard

    private var statusColor: Color {
        guard let data = card.fsrsData else { return NP.Colors.textSecondary }
        if data.reps == 0 { return NP.Colors.accent }
        if data.reps >= 3 && data.stability > 10 { return NP.Colors.success }
        if let nextReview = data.nextReview, nextReview <= Date() { return NP.Colors.error }
        return NP.Colors.primary
    }

    private var statusText: String {
        guard let data = card.fsrsData else { return "New" }
        if data.reps == 0 { return "New" }
        if data.reps >= 3 && data.stability > 10 { return "Mastered" }
        if let nextReview = data.nextReview, nextReview <= Date() { return "Due" }
        return "Learning"
    }

    var body: some View {
        HStack(spacing: NP.Spacing.md) {
            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(card.front)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)
                    .lineLimit(1)

                Text(card.back)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(statusText)
                .font(NP.Typography.caption2Semibold)
                .foregroundColor(statusColor)
                .padding(.horizontal, NP.Spacing.md)
                .padding(.vertical, NP.Spacing.xs)
                .background(statusColor.opacity(0.12))
                .clipShape(Capsule())

            Image(systemName: "chevron.right")
                .font(NP.Typography.caption1)
                .foregroundColor(NP.Colors.textSecondary)
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npSubtleShadow()
    }
}
