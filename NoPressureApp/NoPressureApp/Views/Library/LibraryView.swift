import SwiftUI
import SwiftData
import FabrikaAnalytics

struct LibraryView: View {
    @Query private var decks: [Deck]
    @Environment(\.analyticsService) private var analytics
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var showingBrowseDecks = false

    enum FilterOption: String, CaseIterable {
        case all = "All"
        case recent = "Recent"
        case favorites = "Favorites"
    }

    var filteredDecks: [Deck] {
        var result = decks

        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        switch selectedFilter {
        case .all:
            result = result.sorted { $0.cards.count > $1.cards.count }
        case .recent:
            result = result.sorted { ($0.lastStudied ?? .distantPast) > ($1.lastStudied ?? .distantPast) }
        case .favorites:
            result = result.filter { $0.isFavorite }
        }

        return result
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: 0) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(NP.Colors.textSecondary)

                        TextField("Search decks...", text: $searchText)
                            .foregroundColor(NP.Colors.textPrimary)
                    }
                    .padding(NP.Spacing.md)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                    .npSubtleShadow()
                    .padding(.horizontal, NP.Spacing.xxl)
                    .padding(.top, NP.Spacing.xl)

                    // Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterOption.allCases, id: \.self) { option in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = option
                                    }
                                } label: {
                                    Text(option.rawValue)
                                        .font(NP.Typography.subheadlineSemibold)
                                        .foregroundColor(selectedFilter == option ? .white : NP.Colors.textSecondary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            selectedFilter == option ?
                                            NP.Colors.primary : NP.Colors.surface
                                        )
                                        .clipShape(Capsule())
                                        .shadow(
                                            color: selectedFilter == option ? Color.clear : NP.Shadow.cardColor,
                                            radius: 4, x: 0, y: 2
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                    }
                    .padding(.top, NP.Spacing.lg)

                    // Decks Grid
                    if filteredDecks.isEmpty {
                        Spacer()

                        VStack(spacing: NP.Spacing.lg) {
                            Image("solar-deck")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(NP.Colors.primary)

                            Text(selectedFilter == .favorites ? "No favorite decks" : "No decks yet")
                                .font(NP.Typography.title2)
                                .foregroundColor(NP.Colors.textPrimary)

                            Text(selectedFilter == .favorites
                                 ? "Tap the heart icon on a deck to add it to favorites"
                                 : "Create your first deck to start learning")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NP.Spacing.lg) {
                                ForEach(filteredDecks) { deck in
                                    NavigationLink {
                                        DeckDetailView(deck: deck)
                                    } label: {
                                        DeckGridCard(deck: deck)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(NP.Spacing.xxl)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingBrowseDecks = true
                    } label: {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .foregroundColor(NP.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingBrowseDecks) {
                BrowseDecksView()
            }
            .onAppear {
                analytics.trackScreen("Library", context: modelContext)
            }
        }
    }
}

struct DeckGridCard: View {
    let deck: Deck
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            HStack {
                Image(systemName: deck.icon)
                    .foregroundColor(Color(hex: deck.colorHex))
                    .font(NP.Typography.IconSize.lg)

                Spacer()

                // Favorite button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        deck.isFavorite.toggle()
                        try? modelContext.save()
                    }
                } label: {
                    Image(systemName: deck.isFavorite ? "heart.fill" : "heart")
                        .font(NP.Typography.IconSize.sm)
                        .foregroundColor(deck.isFavorite ? NP.Colors.error : NP.Colors.textSecondary)
                }
            }

            Text(deck.name)
                .font(NP.Typography.bodySemibold)
                .foregroundColor(NP.Colors.textPrimary)
                .lineLimit(2)

            // Description
            if !deck.deckDescription.isEmpty {
                Text(deck.deckDescription)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
                    .lineLimit(2)
            }

            HStack {
                Text("\(deck.cards.count) cards")
                    .font(NP.Typography.caption2Semibold)
                    .foregroundColor(NP.Colors.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(NP.Colors.lightPurple)
                    .clipShape(Capsule())

                Spacer()

                if let lastStudied = deck.lastStudied {
                    Text(timeAgo(lastStudied))
                        .font(NP.Typography.caption2)
                        .foregroundColor(NP.Colors.textSecondary)
                }
            }
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .shadow(
            color: NP.Shadow.cardColor,
            radius: NP.Shadow.cardRadius,
            x: NP.Shadow.cardX,
            y: NP.Shadow.cardY
        )
    }

    private func timeAgo(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour], from: date, to: now)

        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else {
            return "Just now"
        }
    }
}
