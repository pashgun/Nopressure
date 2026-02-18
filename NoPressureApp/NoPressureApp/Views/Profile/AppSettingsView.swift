import SwiftUI

/// App settings: appearance, notifications, about.
struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: NP.Spacing.xxl) {
                        appearanceSection
                        notificationsSection
                        aboutSection
                        Spacer(minLength: 100)
                    }
                    .padding(.top, NP.Spacing.lg)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(NP.Colors.primary)
                }
            }
        }
    }

    private var appearanceSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text("Appearance")
                .font(NP.Typography.title3)
                .foregroundColor(NP.Colors.textBlack)

            VStack(spacing: 0) {
                settingsRow(icon: "paintbrush.fill", title: "Theme", subtitle: "System")
                Divider()
                    .padding(.leading, 56)
                settingsRow(icon: "textformat.size", title: "Text size", subtitle: "Default")
            }
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text("Notifications")
                .font(NP.Typography.title3)
                .foregroundColor(NP.Colors.textBlack)

            VStack(spacing: 0) {
                settingsRow(icon: "bell.fill", title: "Daily reminder", subtitle: "Off")
                Divider()
                    .padding(.leading, 56)
                settingsRow(icon: "calendar", title: "Study reminders", subtitle: "Enabled")
            }
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: NP.Spacing.md) {
            Text("About")
                .font(NP.Typography.title3)
                .foregroundColor(NP.Colors.textBlack)

            VStack(spacing: 0) {
                settingsRow(icon: "info.circle.fill", title: "Version", subtitle: "1.0.0")
                Divider()
                    .padding(.leading, 56)
                settingsRow(icon: "doc.text.fill", title: "Terms of Use", subtitle: "")
                Divider()
                    .padding(.leading, 56)
                settingsRow(icon: "hand.raised.fill", title: "Privacy Policy", subtitle: "")
            }
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
            .npCardShadow()
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    private func settingsRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: NP.Spacing.lg) {
            Image(systemName: icon)
                .font(NP.Typography.IconSize.md)
                .foregroundColor(NP.Colors.primary)
                .frame(width: 28, alignment: .center)

            Text(title)
                .font(NP.Typography.bodySemibold)
                .foregroundColor(NP.Colors.textPrimary)

            Spacer()

            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }

            Image(systemName: "chevron.right")
                .font(NP.Typography.caption1)
                .foregroundColor(NP.Colors.textSecondary)
        }
        .padding(NP.Spacing.lg)
    }
}

#Preview {
    AppSettingsView()
}
