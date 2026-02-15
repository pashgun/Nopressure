import SwiftUI

/// Splash / Welcome screen — matches Figma design
/// White background with organic orange blob shape centered, "no pressure" logo + subtitle
struct WelcomeView: View {
    var onContinue: () -> Void = {}

    @State private var blobPhase: CGFloat = 0

    var body: some View {
        ZStack {
            // White background
            Color.white
                .ignoresSafeArea()

            // Organic orange blob centered
            OrangeBlob(phase: blobPhase)
                .fill(
                    LinearGradient(
                        colors: [
                            NP.Colors.accent.opacity(0.9),
                            NP.Colors.accent
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 340, height: 420)
                .shadow(color: NP.Colors.accent.opacity(0.3), radius: 40, x: 0, y: 20)

            // Text content centered
            VStack(spacing: NP.Spacing.lg) {
                Text("no pressure")
                    .font(NP.Typography.logoTitle)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text("Study flashcards without guilt")
                    .font(NP.Typography.title3)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            // Tap anywhere to continue (splash auto-advances or tap)
            VStack {
                Spacer()

                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        onContinue()
                    }
                } label: {
                    Text("Get Started")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(NP.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                blobPhase = 1
            }
        }
    }
}

// MARK: - Organic Blob Shape (mimics Figma's wavy blob)

struct OrangeBlob: Shape {
    var phase: CGFloat = 0

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let cx = w / 2
        let cy = h / 2

        // Radii for 8 control points around the blob, with gentle animation
        let baseRadii: [CGFloat] = [0.46, 0.50, 0.44, 0.52, 0.48, 0.42, 0.50, 0.45]
        let animOffsets: [CGFloat] = [0.03, -0.02, 0.04, -0.03, 0.02, 0.04, -0.03, 0.02]

        let n = baseRadii.count
        var points: [CGPoint] = []

        for i in 0..<n {
            let angle = (CGFloat(i) / CGFloat(n)) * 2 * .pi - .pi / 2
            let r = (baseRadii[i] + animOffsets[i] * phase) * min(w, h)
            let x = cx + r * cos(angle)
            let y = cy + r * sin(angle)
            points.append(CGPoint(x: x, y: y))
        }

        var path = Path()
        path.move(to: points[0])

        for i in 0..<n {
            let current = points[i]
            let next = points[(i + 1) % n]
            let cp1 = CGPoint(
                x: current.x + (next.x - points[(i + n - 1) % n].x) / 4,
                y: current.y + (next.y - points[(i + n - 1) % n].y) / 4
            )
            let cp2 = CGPoint(
                x: next.x - (points[(i + 2) % n].x - current.x) / 4,
                y: next.y - (points[(i + 2) % n].y - current.y) / 4
            )
            path.addCurve(to: next, control1: cp1, control2: cp2)
        }

        path.closeSubpath()
        return path
    }
}
