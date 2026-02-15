import SwiftUI

struct FeaturePage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct HowItWorksView: View {
    @Binding var currentPage: Int
    let onComplete: () -> Void

    let features = [
        FeaturePage(
            icon: "camera.fill",
            title: "Snap & Learn",
            description: "AI creates flashcards from photos, PDFs, or text"
        ),
        FeaturePage(
            icon: "heart.fill",
            title: "No Guilt, No Burnout",
            description: "Miss a day? No problem. No streaks, no pressure."
        ),
        FeaturePage(
            icon: "brain.head.profile",
            title: "Smart Repetition",
            description: "FSRS algorithm shows cards at optimal time"
        )
    ]

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: 0) {
                Spacer()

                // Feature Content
                TabView(selection: $currentPage) {
                    ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                        VStack(spacing: NP.Spacing.xxxl) {
                            // Icon in a circle
                            ZStack {
                                Circle()
                                    .fill(NP.Colors.lightPurple)
                                    .frame(width: 120, height: 120)

                                Image(systemName: feature.icon)
                                    .font(NP.Typography.IconSize.hero)
                                    .foregroundColor(NP.Colors.primary)
                            }

                            VStack(spacing: NP.Spacing.lg) {
                                Text(feature.title)
                                    .font(NP.Typography.title1)
                                    .foregroundColor(NP.Colors.textBlack)
                                    .multilineTextAlignment(.center)

                                Text(feature.description)
                                    .font(NP.Typography.body)
                                    .foregroundColor(NP.Colors.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 48)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 400)

                Spacer()

                // Continue Button
                Button {
                    if currentPage < features.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text(currentPage < features.count - 1 ? "Continue" : "Get Started")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(NP.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
