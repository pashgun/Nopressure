import SwiftUI

struct FeaturePage: Identifiable {
    let id = UUID()
    let icon: String          // SF Symbol name
    let subtitle: String      // Small caps label
    let title: String         // Large title
    let description: String   // Description text
    let blobAlignment: Alignment // Where the orange blob appears
}

/// Onboarding feature showcase — matches Figma (node 1-1209 / 1-1299)
/// White background, illustration area at top with orange blob accents,
/// white card at bottom with subtitle, title, and CTA button
struct HowItWorksView: View {
    @Binding var currentPage: Int
    let onComplete: () -> Void

    let features = [
        FeaturePage(
            icon: "camera.viewfinder",
            subtitle: "SNAP & LEARN",
            title: "Turn anything into\nflashcards",
            description: "AI creates flashcards from photos, PDFs, or text in seconds",
            blobAlignment: .topLeading
        ),
        FeaturePage(
            icon: "heart.circle",
            subtitle: "NO GUILT",
            title: "Miss a day?\nNo problem.",
            description: "No streaks, no pressure. Learn at your own pace",
            blobAlignment: .bottomTrailing
        ),
        FeaturePage(
            icon: "brain.head.profile",
            subtitle: "SMART REPETITION",
            title: "Remember\neverything",
            description: "FSRS algorithm shows cards at the optimal time for your memory",
            blobAlignment: .topTrailing
        )
    ]

    var body: some View {
        ZStack {
            // White background
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top: illustration area with orange blob accents
                ZStack {
                    // Orange blob decorations (like Figma corners)
                    orangeBlobDecoration(alignment: features[currentPage].blobAlignment)

                    // Illustration — SF Symbol as large icon with purple styling
                    illustrationArea(for: features[currentPage])
                }
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.50)

                // Bottom: white card with rounded top
                VStack(spacing: 0) {
                    // Page dots
                    HStack(spacing: 8) {
                        ForEach(0..<features.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? NP.Colors.primary : NP.Colors.lightPurple)
                                .frame(width: index == currentPage ? 10 : 8,
                                       height: index == currentPage ? 10 : 8)
                        }
                    }
                    .padding(.top, 28)
                    .padding(.bottom, 20)

                    // Subtitle — small caps tracking
                    Text(features[currentPage].subtitle)
                        .font(NP.Typography.overline)
                        .foregroundColor(NP.Colors.textSecondary)
                        .tracking(2)
                        .padding(.bottom, 16)

                    // Title
                    Text(features[currentPage].title)
                        .font(NP.Typography.title1)
                        .foregroundColor(NP.Colors.textBlack)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 12)

                    // Description
                    Text(features[currentPage].description)
                        .font(NP.Typography.body)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()

                    // CTA Button — purple filled
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
                    .padding(.horizontal, 24)

                    // Skip
                    if currentPage < features.count - 1 {
                        Button {
                            onComplete()
                        } label: {
                            Text("Skip")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                        .padding(.top, 12)
                    }

                    Spacer().frame(height: 32)
                }
                .frame(maxWidth: .infinity)
                .background(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 32,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 32
                    )
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: -6)
                )
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50, currentPage < features.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) { currentPage += 1 }
                    } else if value.translation.width > 50, currentPage > 0 {
                        withAnimation(.easeInOut(duration: 0.3)) { currentPage -= 1 }
                    }
                }
        )
        .animation(.easeInOut(duration: 0.35), value: currentPage)
    }

    // MARK: - Orange Blob Decoration (corner blobs like Figma)

    @ViewBuilder
    private func orangeBlobDecoration(alignment: Alignment) -> some View {
        GeometryReader { geo in
            ZStack {
                // Primary blob
                OrangeBlob(phase: 0.5)
                    .fill(
                        LinearGradient(
                            colors: [NP.Colors.accent.opacity(0.7), NP.Colors.accent.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 200)
                    .position(blobPosition(for: alignment, in: geo.size, isPrimary: true))

                // Secondary smaller blob
                OrangeBlob(phase: 0.2)
                    .fill(NP.Colors.accent.opacity(0.25))
                    .frame(width: 120, height: 140)
                    .position(blobPosition(for: alignment, in: geo.size, isPrimary: false))
            }
        }
    }

    private func blobPosition(for alignment: Alignment, in size: CGSize, isPrimary: Bool) -> CGPoint {
        switch alignment {
        case .topLeading:
            return isPrimary
                ? CGPoint(x: -20, y: 30)
                : CGPoint(x: 60, y: 130)
        case .topTrailing:
            return isPrimary
                ? CGPoint(x: size.width + 20, y: 40)
                : CGPoint(x: size.width - 50, y: 140)
        case .bottomTrailing:
            return isPrimary
                ? CGPoint(x: size.width + 10, y: size.height - 20)
                : CGPoint(x: size.width - 60, y: size.height - 80)
        default:
            return isPrimary
                ? CGPoint(x: -10, y: size.height - 30)
                : CGPoint(x: 70, y: size.height - 100)
        }
    }

    // MARK: - Illustration Area

    @ViewBuilder
    private func illustrationArea(for page: FeaturePage) -> some View {
        VStack(spacing: 16) {
            // Large icon as illustration placeholder
            // (Replace with actual doodle art assets when available)
            ZStack {
                // Purple circle background
                Circle()
                    .fill(NP.Colors.lightPurple.opacity(0.3))
                    .frame(width: 180, height: 180)

                Image(systemName: page.icon)
                    .font(.system(size: 72, weight: .light))
                    .foregroundColor(NP.Colors.primary)
            }
        }
    }
}
