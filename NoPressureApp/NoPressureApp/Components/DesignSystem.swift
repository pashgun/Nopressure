import SwiftUI

// MARK: - NoPressure Design System
// Extracted pixel-perfect from Figma file d9jhBj7g7XnKK5L14M9RAL

enum NP {

    // MARK: - Colors (exact Figma hex values)

    enum Colors {
        /// Primary purple — #5533FF — CTA buttons, active tab, links
        static let primary = Color(hex: "#5533FF")

        /// Accent orange — #FF7A4D — highlights, tags, illustrations
        static let accent = Color(hex: "#FF7A4D")

        /// App background lavender — #EBE8FC
        static let background = Color(hex: "#EBE8FC")

        /// Light purple tint — #D4CCFF — secondary backgrounds, pill badges
        static let lightPurple = Color(hex: "#D4CCFF")

        /// Light orange tint — #FFD9CC — secondary accents
        static let lightOrange = Color(hex: "#FFD9CC")

        /// Card / surface white — #FFFFFF
        static let surface = Color.white

        /// Primary text (dark) — #333333
        static let textPrimary = Color(hex: "#333333")

        /// Secondary text (gray) — #999999
        static let textSecondary = Color(hex: "#999999")

        /// Headings / emphatic text — #000000
        static let textBlack = Color.black

        /// Tab bar background — white with slight opacity
        static let tabBarBackground = Color.white
    }

    // MARK: - Typography (SF Pro — iOS system font)
    // All sizes, weights, and line heights from Figma

    enum Typography {
        // Large Title — 34px Bold, line 41, spacing 0.4
        static let largeTitle = Font.system(size: 34, weight: .bold)

        // Title 1 — 28px Bold, line 34, spacing 0.38
        static let title1 = Font.system(size: 28, weight: .bold)

        // Title 2 — 22px Bold, line 28, spacing -0.26
        static let title2 = Font.system(size: 22, weight: .bold)

        // Title 3 — 20px Semibold, line 25, spacing -0.45
        static let title3 = Font.system(size: 20, weight: .semibold)

        // Body — 17px Regular, line 22, spacing -0.43
        static let body = Font.system(size: 17, weight: .regular)

        // Body Semibold — 17px Semibold, line 22
        static let bodySemibold = Font.system(size: 17, weight: .semibold)

        // Headline — 17px Semibold, line 22
        static let headline = Font.system(size: 17, weight: .semibold)

        // Callout — 16px Regular, line 21
        static let callout = Font.system(size: 16, weight: .regular)

        // Callout Semibold — 16px Semibold
        static let calloutSemibold = Font.system(size: 16, weight: .semibold)

        // Subheadline — 15px Regular, line 20
        static let subheadline = Font.system(size: 15, weight: .regular)

        // Subheadline Semibold — 15px Semibold
        static let subheadlineSemibold = Font.system(size: 15, weight: .semibold)

        // Footnote — 13px Regular
        static let footnote = Font.system(size: 13, weight: .regular)

        // Footnote Semibold — 13px Semibold
        static let footnoteSemibold = Font.system(size: 13, weight: .semibold)

        // Caption 1 — 12px Regular
        static let caption1 = Font.system(size: 12, weight: .regular)

        // Caption 1 Medium — 12px Medium
        static let caption1Medium = Font.system(size: 12, weight: .medium)

        // Caption 1 Semibold — 12px Semibold
        static let caption1Semibold = Font.system(size: 12, weight: .semibold)

        // Caption 2 — 11px Regular
        static let caption2 = Font.system(size: 11, weight: .regular)

        // Caption 2 Semibold — 11px Semibold
        static let caption2Semibold = Font.system(size: 11, weight: .semibold)

        // Progress ring percentage — 32px w800
        static let progressLarge = Font.system(size: 32, weight: .heavy)

        // Stat value (Profile) — 32px Bold
        static let statValue = Font.system(size: 32, weight: .bold)

        // Card face text (Study flip card) — 28px Semibold
        static let cardFace = Font.system(size: 28, weight: .semibold)

        // Question title (Quiz/Write modes) — 24px Bold
        static let questionTitle = Font.system(size: 24, weight: .bold)

        // Welcome logo text — 42px Bold
        static let logoTitle = Font.system(size: 42, weight: .bold)

        // Icon sizes (for SF Symbol sizing, not text typography)
        enum IconSize {
            static let xs = Font.system(size: 12, weight: .bold)
            static let sm = Font.system(size: 16, weight: .semibold)
            static let md = Font.system(size: 20, weight: .semibold)
            static let lg = Font.system(size: 24)
            static let xl = Font.system(size: 28)
            static let xxl = Font.system(size: 32)
            static let hero = Font.system(size: 48)
            static let splash = Font.system(size: 72)
            static let illustration = Font.system(size: 80)
        }
    }

    // MARK: - Spacing & Radius

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }

    enum Radius {
        /// Small cards, buttons
        static let sm: CGFloat = 12
        /// Medium cards
        static let md: CGFloat = 16
        /// Large cards, hero card
        static let lg: CGFloat = 20
        /// Extra large (sheets)
        static let xl: CGFloat = 24
        /// Pill / capsule
        static let pill: CGFloat = 100
    }

    // MARK: - Shadows (from Figma "Card Shadow" style)

    enum Shadow {
        static let cardColor = Color.black.opacity(0.08)
        static let cardRadius: CGFloat = 16
        static let cardX: CGFloat = 0
        static let cardY: CGFloat = 4
    }
}

// MARK: - Reusable View Modifiers

/// White card with shadow — replaces old GlassCard
struct NPCard: ViewModifier {
    var radius: CGFloat = NP.Radius.lg

    func body(content: Content) -> some View {
        content
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(
                color: NP.Shadow.cardColor,
                radius: NP.Shadow.cardRadius,
                x: NP.Shadow.cardX,
                y: NP.Shadow.cardY
            )
    }
}

/// Purple filled button (primary CTA)
struct NPPrimaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(NP.Typography.bodySemibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(NP.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
    }
}

/// Light purple outlined / tinted button (secondary)
struct NPSecondaryButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(NP.Typography.bodySemibold)
            .foregroundColor(NP.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(NP.Colors.lightPurple.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
    }
}

// MARK: - View Extensions

extension View {
    /// White card with shadow — primary surface component
    func npCard(radius: CGFloat = NP.Radius.lg) -> some View {
        modifier(NPCard(radius: radius))
    }

    /// Purple CTA button style
    func npPrimaryButton() -> some View {
        modifier(NPPrimaryButton())
    }

    /// Secondary button style
    func npSecondaryButton() -> some View {
        modifier(NPSecondaryButton())
    }
}

// MARK: - App Background

struct NPBackground: View {
    var body: some View {
        NP.Colors.background
            .ignoresSafeArea()
    }
}
