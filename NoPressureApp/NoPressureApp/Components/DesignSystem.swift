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

    // MARK: - Font Names
    // Manrope (primary), SF Pro (system fallback), IBM Plex Mono (monospace)

    enum FontName {
        static let manrope = "Manrope"
        static let ibmPlexMono = "IBMPlexMono"
    }

    // MARK: - Typography
    // Manrope variable font: weight axis 200–800
    // iOS maps Font.custom + weight via the variable font's wght axis

    enum Typography {
        // — Manrope helpers —
        // Variable font: we set size and use .weight() modifier for the axis
        private static func manrope(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            Font.custom(FontName.manrope, size: size).weight(weight)
        }

        private static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            Font.custom(FontName.ibmPlexMono, size: size).weight(weight)
        }

        // Large Title — 34px Bold
        static let largeTitle = manrope(34, weight: .bold)

        // Title 1 — 28px Bold
        static let title1 = manrope(28, weight: .bold)

        // Title 2 — 22px Bold
        static let title2 = manrope(22, weight: .bold)

        // Title 3 — 20px Semibold
        static let title3 = manrope(20, weight: .semibold)

        // Body — 17px Regular
        static let body = manrope(17)

        // Body Semibold — 17px Semibold
        static let bodySemibold = manrope(17, weight: .semibold)

        // Headline — 17px Semibold
        static let headline = manrope(17, weight: .semibold)

        // Callout — 16px Regular
        static let callout = manrope(16)

        // Callout Semibold — 16px Semibold
        static let calloutSemibold = manrope(16, weight: .semibold)

        // Subheadline — 15px Regular
        static let subheadline = manrope(15)

        // Subheadline Semibold — 15px Semibold
        static let subheadlineSemibold = manrope(15, weight: .semibold)

        // Footnote — 13px Regular
        static let footnote = manrope(13)

        // Footnote Semibold — 13px Semibold
        static let footnoteSemibold = manrope(13, weight: .semibold)

        // Caption 1 — 12px Regular
        static let caption1 = manrope(12)

        // Caption 1 Medium — 12px Medium
        static let caption1Medium = manrope(12, weight: .medium)

        // Caption 1 Semibold — 12px Semibold
        static let caption1Semibold = manrope(12, weight: .semibold)

        // Caption 2 — 11px Regular
        static let caption2 = manrope(11)

        // Caption 2 Semibold — 11px Semibold
        static let caption2Semibold = manrope(11, weight: .semibold)

        // Progress ring percentage — 32px ExtraBold
        static let progressLarge = manrope(32, weight: .heavy)

        // Stat value (Profile) — 32px Bold
        static let statValue = manrope(32, weight: .bold)

        // Card face text (Study flip card) — 28px Semibold
        static let cardFace = manrope(28, weight: .semibold)

        // Question title (Quiz/Write modes) — 24px Bold
        static let questionTitle = manrope(24, weight: .bold)

        // Welcome logo text — 42px Bold
        static let logoTitle = manrope(42, weight: .bold)

        // Monospace — IBM Plex Mono
        static let monoBody = mono(15)
        static let monoCaption = mono(12)
        static let monoSmall = mono(11)

        // Label — small caps / all-caps labels
        static let overline = manrope(11, weight: .semibold)

        // Icon sizes (for SF Symbol sizing, not text typography — keep system font)
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
