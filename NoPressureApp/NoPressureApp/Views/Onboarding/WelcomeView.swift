import SwiftUI

/// Splash / Welcome screen — matches Figma "Splash" (node 2:889)
/// Orange blob background with "no pressure" logo and subtitle
struct WelcomeView: View {
    var onContinue: () -> Void = {}

    var body: some View {
        ZStack {
            // Splash background — orange accent
            NP.Colors.accent
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Logo and Title
                VStack(spacing: NP.Spacing.lg) {
                    // Decorative circle (matches Figma Splash blob)
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 80, height: 80)
                        )

                    Text("no pressure")
                        .font(NP.Typography.logoTitle)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Study flashcards without guilt")
                        .font(NP.Typography.title3)
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                // Get Started Button — white on orange bg
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        onContinue()
                    }
                } label: {
                    Text("Get Started")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(NP.Colors.accent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 60)
            }
        }
    }
}
