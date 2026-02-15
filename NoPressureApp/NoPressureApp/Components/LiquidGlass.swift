import SwiftUI

// MARK: - Glass Card → White Card with Shadow
// Keeps the same API names for backward compatibility
// but now uses the new light design system from Figma

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
            .shadow(
                color: NP.Shadow.cardColor,
                radius: NP.Shadow.cardRadius,
                x: NP.Shadow.cardX,
                y: NP.Shadow.cardY
            )
    }
}

// MARK: - Liquid Button → Purple CTA Button
struct LiquidButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(NP.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
    }
}

// MARK: - Liquid Glass → White Card (General purpose)
struct LiquidGlass: ViewModifier {
    var cornerRadius: CGFloat = NP.Radius.xl
    var blurRadius: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: NP.Shadow.cardColor,
                radius: NP.Shadow.cardRadius,
                x: NP.Shadow.cardX,
                y: NP.Shadow.cardY
            )
    }
}

// MARK: - View Extensions (unchanged API)
extension View {
    func liquidGlass(cornerRadius: CGFloat = NP.Radius.xl) -> some View {
        modifier(LiquidGlass(cornerRadius: cornerRadius))
    }

    func glassCard() -> some View {
        modifier(GlassCard())
    }

    func liquidButton() -> some View {
        modifier(LiquidButton())
    }
}
