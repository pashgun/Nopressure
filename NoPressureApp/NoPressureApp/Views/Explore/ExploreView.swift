import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""

    let categories = [
        ("Languages", "globe", "#5533FF"),
        ("Science", "atom", "#FF7A4D"),
        ("Math", "function", "#5533FF"),
        ("History", "clock.fill", "#FF7A4D"),
        ("Medicine", "cross.case.fill", "#5533FF"),
        ("Tech", "desktopcomputer", "#FF7A4D")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(NP.Colors.textSecondary)

                            TextField("Search topics...", text: $searchText)
                                .foregroundColor(NP.Colors.textPrimary)
                        }
                        .padding(12)
                        .background(NP.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.sm, style: .continuous))
                        .shadow(color: NP.Shadow.cardColor, radius: 4, x: 0, y: 2)
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, 20)

                        // Categories
                        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                            Text("Browse Categories")
                                .font(NP.Typography.title2)
                                .foregroundColor(NP.Colors.textBlack)
                                .padding(.horizontal, NP.Spacing.xxl)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NP.Spacing.lg) {
                                ForEach(categories, id: \.0) { category in
                                    CategoryCard(
                                        title: category.0,
                                        icon: category.1,
                                        color: category.2
                                    )
                                }
                            }
                            .padding(.horizontal, NP.Spacing.xxl)
                        }

                        // Featured Section
                        VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                            Text("Featured Decks")
                                .font(NP.Typography.title2)
                                .foregroundColor(NP.Colors.textBlack)
                                .padding(.horizontal, NP.Spacing.xxl)

                            Text("Coming soon...")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                                .padding(.horizontal, NP.Spacing.xxl)
                        }

                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CategoryCard: View {
    let title: String
    let icon: String
    let color: String

    var body: some View {
        Button {
            // Navigate to category
        } label: {
            VStack(spacing: NP.Spacing.md) {
                Image(systemName: icon)
                    .font(NP.Typography.IconSize.xl)
                    .foregroundColor(Color(hex: color))

                Text(title)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NP.Spacing.xxl)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .shadow(
                color: NP.Shadow.cardColor,
                radius: NP.Shadow.cardRadius,
                x: NP.Shadow.cardX,
                y: NP.Shadow.cardY
            )
        }
    }
}
