import SwiftUI
import SwiftData

struct BrowseDecksView: View {
    @Query private var existingDecks: [Deck]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedCategory: String = "All"
    @State private var importedIds: Set<String> = []
    @State private var showingToast = false
    @State private var toastMessage = ""

    private let bundledDecks = BundledDecksService.allDecks

    private var categories: [String] {
        var cats = Set(bundledDecks.map { $0.category })
        return ["All"] + cats.sorted()
    }

    private var filteredDecks: [BundledDeck] {
        var result = bundledDecks

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        if selectedCategory != "All" {
            result = result.filter { $0.category == selectedCategory }
        }

        return result
    }

    private func isAlreadyImported(_ deck: BundledDeck) -> Bool {
        importedIds.contains(deck.id) ||
        BundledDecksService.isImported(bundledId: deck.id, in: existingDecks)
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
                    .padding(.top, NP.Spacing.lg)

                    // Category Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: NP.Spacing.sm) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCategory = category
                                    }
                                } label: {
                                    Text(category)
                                        .font(NP.Typography.caption2Semibold)
                                        .foregroundColor(selectedCategory == category ? .white : NP.Colors.textSecondary)
                                        .padding(.horizontal, NP.Spacing.lg)
                                        .padding(.vertical, NP.Spacing.sm)
                                        .background(selectedCategory == category ? NP.Colors.primary : NP.Colors.surface)
                                        .clipShape(Capsule())
                                        .npSubtleShadow()
                                }
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                    }
                    .padding(.top, NP.Spacing.md)

                    // Deck List
                    ScrollView {
                        LazyVStack(spacing: NP.Spacing.md) {
                            ForEach(filteredDecks) { deck in
                                BrowseDeckCard(
                                    deck: deck,
                                    isImported: isAlreadyImported(deck),
                                    onAdd: {
                                        addDeck(deck)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.lg)
                        .padding(.bottom, 100)
                    }
                }

                // Toast
                if showingToast {
                    VStack {
                        Spacer()

                        Text(toastMessage)
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, NP.Spacing.xxl)
                            .padding(.vertical, NP.Spacing.lg)
                            .background(NP.Colors.success)
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 60)
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showingToast)
                }
            }
            .navigationTitle("Browse Decks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(NP.Colors.primary)
                }
            }
        }
    }

    private func addDeck(_ bundled: BundledDeck) {
        BundledDecksService.importDeck(bundled, into: modelContext)
        importedIds.insert(bundled.id)

        toastMessage = "\(bundled.name) added!"
        withAnimation {
            showingToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingToast = false
            }
        }
    }
}

// MARK: - Browse Deck Card

struct BrowseDeckCard: View {
    let deck: BundledDeck
    let isImported: Bool
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: NP.Spacing.lg) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous)
                    .fill(Color(hex: deck.colorHex).opacity(0.15))
                    .frame(width: 52, height: 52)

                Image(systemName: deck.icon)
                    .font(NP.Typography.IconSize.md)
                    .foregroundColor(Color(hex: deck.colorHex))
            }

            // Text
            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                Text(deck.name)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)

                Text(deck.description)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
                    .lineLimit(2)

                HStack(spacing: NP.Spacing.md) {
                    Label("\(deck.cards.count) cards", systemImage: "rectangle.stack")
                        .font(NP.Typography.caption2)
                        .foregroundColor(NP.Colors.textSecondary)

                    Text(deck.category)
                        .font(NP.Typography.caption2Semibold)
                        .foregroundColor(NP.Colors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(NP.Colors.lightPurple)
                        .clipShape(Capsule())
                }
            }

            Spacer()

            // Add button
            if isImported {
                HStack(spacing: NP.Spacing.xs) {
                    Image(systemName: "checkmark")
                        .font(NP.Typography.caption1)
                    Text("Added")
                        .font(NP.Typography.caption1Semibold)
                }
                .foregroundColor(NP.Colors.success)
                .padding(.horizontal, NP.Spacing.lg)
                .padding(.vertical, NP.Spacing.sm)
                .background(NP.Colors.success.opacity(0.12))
                .clipShape(Capsule())
            } else {
                Button {
                    onAdd()
                } label: {
                    HStack(spacing: NP.Spacing.xs) {
                        Image(systemName: "plus")
                            .font(NP.Typography.caption1)
                        Text("Add")
                            .font(NP.Typography.caption1Semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, NP.Spacing.lg)
                    .padding(.vertical, NP.Spacing.sm)
                    .background(NP.Colors.primary)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(NP.Spacing.lg)
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .npCardShadow()
    }
}

#Preview {
    BrowseDecksView()
}
