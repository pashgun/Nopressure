import SwiftUI

struct FeaturePage: Identifiable {
    let id = UUID()
    let emoji: String
    let subtitle: String
    let title: String
    let description: String
    let accentColor: Color
}

/// Onboarding feature showcase — matches Figma (node 1-1209)
/// Full-screen illustration area at top, white card at bottom
struct HowItWorksView: View {
    @Binding var currentPage: Int
    let onComplete: () -> Void

    let features = [
        FeaturePage(
            emoji: "📸",
            subtitle: "SNAP & LEARN",
            title: "Turn anything into\nflashcards",
            description: "AI creates flashcards from photos, PDFs, or text in seconds",
            accentColor: NP.Colors.accent
        ),
        FeaturePage(
            emoji: "💜",
            subtitle: "NO GUILT",
            title: "Miss a day?\nNo problem.",
            description: "No streaks, no pressure. Learn at your own pace",
            accentColor: NP.Colors.primary
        ),
        FeaturePage(
            emoji: "🧠",
            subtitle: "SMART REPETITION",
            title: "Remember\neverything",
            description: "FSRS algorithm shows cards at the optimal time for your memory",
            accentColor: NP.Colors.accent
        )
    ]

    var body: some View {
        ZStack {
            // Background fills full screen
            NP.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top: illustration area with colored blob
                ZStack {
                    // Decorative blob
                    illustrationArea(for: features[currentPage])
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom: white card with content
                VStack(spacing: NP.Spacing.xxl) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<features.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? NP.Colors.primary : NP.Colors.lightPurple)
                                .frame(width: index == currentPage ? 10 : 8,
                                       height: index == currentPage ? 10 : 8)
                                .animation(.easeInOut(duration: 0.2), value: currentPage)
                        }
                    }
                    .padding(.top, NP.Spacing.xxl)

                    // Subtitle — small caps
                    Text(features[currentPage].subtitle)
                        .font(NP.Typography.overline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .tracking(2)

                    // Title — large
                    Text(features[currentPage].title)
                        .font(NP.Typography.title1)
                        .foregroundColor(NP.Colors.textBlack)
                        .multilineTextAlignment(.center)

                    // Description
                    Text(features[currentPage].description)
                        .font(NP.Typography.body)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, NP.Spacing.xxl)

                    Spacer()

                    // CTA Button
                    Button {
                        if currentPage < features.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    } label: {
                        Text(currentPage < features.count - 1 ? "Continue" : "Get Started")
                            .npPrimaryButton()
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    // Skip button
                    if currentPage < features.count - 1 {
                        Button {
                            onComplete()
                        } label: {
                            Text("Skip")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                    }

                    Spacer().frame(height: 20)
                }
                .frame(height: UIScreen.main.bounds.height * 0.45)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: NP.Radius.xl,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: NP.Radius.xl
                    )
                    .fill(NP.Colors.surface)
                    .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
                    .ignoresSafeArea(.container, edges: .bottom)
                )
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50, currentPage < features.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else if value.translation.width > 50, currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage -= 1
                        }
                    }
                }
        )
    }

    // MARK: - Illustration Area

    @ViewBuilder
    private func illustrationArea(for page: FeaturePage) -> some View {
        ZStack {
            // Decorative blob
            Circle()
                .fill(page.accentColor.opacity(0.15))
                .frame(width: 280, height: 280)
                .offset(x: -20, y: 20)

            Circle()
                .fill(page.accentColor.opacity(0.08))
                .frame(width: 200, height: 200)
                .offset(x: 80, y: -40)

            // Large emoji as placeholder for illustration
            Text(page.emoji)
                .font(.system(size: 100))
        }
    }
}
