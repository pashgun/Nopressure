import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCreate = false
    @State private var createdDeck: Deck?

    var body: some View {
        ZStack(alignment: .bottom) {
            // Full-screen background
            NP.Colors.background
                .ignoresSafeArea()

            // Tab content
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView()
                    case 1:
                        LibraryView()
                    case 2:
                        ProfileView()
                    default:
                        HomeView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.bottom, 80) // Space for floating tab bar

            // Floating tab bar + FAB overlay
            VStack(spacing: 0) {
                Spacer()

                ZStack(alignment: .topTrailing) {
                    // Floating pill tab bar
                    floatingTabBar

                    // FAB — floats above the tab bar, right side
                    fab
                        .offset(x: -NP.Spacing.sm, y: -28)
                }
                .padding(.bottom, NP.Spacing.xxl) // Bottom safe area padding
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showingCreate) {
            CreateView(onDeckCreated: { deck in
                createdDeck = deck
                showingCreate = false
            })
        }
        .fullScreenCover(item: $createdDeck) { deck in
            NavigationStack {
                DeckDetailView(deck: deck)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Done") {
                                createdDeck = nil
                            }
                            .foregroundColor(NP.Colors.primary)
                        }
                    }
            }
        }
    }

    // MARK: - Floating Pill Tab Bar

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", iconOutline: "house", label: "Home", tag: 0)
            tabItem(icon: "book.fill", iconOutline: "book", label: "Library", tag: 1)
            tabItem(icon: "person.fill", iconOutline: "person", label: "Profile", tag: 2)
        }
        .padding(.horizontal, NP.Spacing.lg)
        .padding(.vertical, NP.Spacing.md)
        .background(
            Capsule()
                .fill(NP.Colors.surface)
                .shadow(
                    color: NP.Shadow.cardColor,
                    radius: NP.Shadow.cardRadius,
                    x: NP.Shadow.cardX,
                    y: NP.Shadow.cardY
                )
        )
        .padding(.horizontal, NP.Spacing.xxl)
    }

    private func tabItem(icon: String, iconOutline: String, label: String, tag: Int) -> some View {
        let isSelected = selectedTab == tag
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: NP.Spacing.xs) {
                Image(systemName: isSelected ? icon : iconOutline)
                    .font(NP.Typography.IconSize.md)
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)

                Text(label)
                    .font(NP.Typography.caption2)
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NP.Spacing.xs)
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            showingCreate = true
        } label: {
            Image(systemName: "plus")
                .font(NP.Typography.IconSize.lg)
                .foregroundColor(.white)
                .frame(width: NP.Size.fabSize, height: NP.Size.fabSize)
                .background(NP.Colors.primary)
                .clipShape(Circle())
                .shadow(
                    color: NP.Colors.primary.opacity(0.4),
                    radius: 12,
                    x: 0,
                    y: 4
                )
        }
    }
}
