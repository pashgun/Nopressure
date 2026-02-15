import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCreate = false

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
                        ExploreView()
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
                        .offset(x: -8, y: -28)
                }
                .padding(.bottom, 24) // Bottom safe area padding
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showingCreate) {
            CreateView()
        }
    }

    // MARK: - Floating Pill Tab Bar

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            tabItem(icon: "house.fill", iconOutline: "house", label: "Home", tag: 0)
            tabItem(icon: "safari.fill", iconOutline: "safari", label: "Explore", tag: 1)
            tabItem(icon: "person.fill", iconOutline: "person", label: "Profile", tag: 2)
        }
        .padding(.horizontal, NP.Spacing.lg)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(NP.Colors.surface)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 16,
                    x: 0,
                    y: 4
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
            VStack(spacing: 4) {
                Image(systemName: isSelected ? icon : iconOutline)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)

                Text(label)
                    .font(NP.Typography.caption2)
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            showingCreate = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
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
