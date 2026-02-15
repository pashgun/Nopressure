import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingCreate = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                ExploreView()
                    .tag(1)

                ProfileView()
                    .tag(2)
            }

            // Custom Tab Bar (matches Figma: white bg, 3 tabs, purple active)
            customTabBar

            // Floating Action Button (+)
            fab
                .offset(y: -32)
        }
        .sheet(isPresented: $showingCreate) {
            CreateView()
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack {
            solarTabItem(boldIcon: "solar-home-smile-bold", linearIcon: "solar-home-smile-linear", label: "Home", tag: 0)
            Spacer()
            solarTabItem(boldIcon: "solar-compass-bold", linearIcon: "solar-compass-linear", label: "Explore", tag: 1)
            Spacer()
            // Space for FAB
            Color.clear.frame(width: 56)
            Spacer()
            solarTabItem(boldIcon: "solar-user-bold", linearIcon: "solar-user-linear", label: "Profile", tag: 2)
            Spacer()
            // Balance spacer
            Color.clear.frame(width: 0)
        }
        .padding(.horizontal, NP.Spacing.xxl)
        .padding(.top, 12)
        .padding(.bottom, 28) // safe area padding
        .background(
            NP.Colors.surface
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -2)
        )
    }

    private func solarTabItem(boldIcon: String, linearIcon: String, label: String, tag: Int) -> some View {
        let isSelected = selectedTab == tag
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: 4) {
                Image(isSelected ? boldIcon : linearIcon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)

                Text(label)
                    .font(NP.Typography.caption2)
                    .foregroundColor(isSelected ? NP.Colors.primary : NP.Colors.textSecondary)
            }
            .frame(minWidth: 60)
        }
    }

    // MARK: - FAB

    private var fab: some View {
        Button {
            showingCreate = true
        } label: {
            Image("solar-add")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
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
