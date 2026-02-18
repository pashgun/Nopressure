import SwiftUI

struct CreateView: View {
    /// Called with the created deck after save; parent should dismiss this view and navigate to DeckDetail.
    var onDeckCreated: ((Deck) -> Void)?

    @State private var showingManualCreate = false
    @State private var showingCameraCapture = false
    @State private var showingPDFImport = false
    @State private var showingTextImport = false

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                VStack(spacing: NP.Spacing.xxl) {
                    Text("Create Flashcards")
                        .font(NP.Typography.largeTitle)
                        .foregroundColor(NP.Colors.textBlack)
                        .padding(.top, 60)

                    Spacer()

                    // Three input options
                    VStack(spacing: NP.Spacing.lg) {
                        CreateOptionCard(
                            icon: "camera.fill",
                            emoji: "📷",
                            title: "Camera",
                            subtitle: "Snap notes or textbook"
                        ) {
                            showingCameraCapture = true
                        }

                        CreateOptionCard(
                            icon: "doc.fill",
                            emoji: "📄",
                            title: "PDF",
                            subtitle: "Import documents"
                        ) {
                            showingPDFImport = true
                        }

                        CreateOptionCard(
                            icon: "text.alignleft",
                            emoji: "✍️",
                            title: "Text",
                            subtitle: "Paste or type"
                        ) {
                            showingTextImport = true
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    Spacer()

                    Button {
                        showingManualCreate = true
                    } label: {
                        Text("Create Manually")
                            .font(NP.Typography.subheadlineSemibold)
                            .foregroundColor(NP.Colors.primary)
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingManualCreate) {
                ManualCreateView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingManualCreate = false
                })
            }
            .sheet(isPresented: $showingCameraCapture) {
                CameraCaptureView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingCameraCapture = false
                })
            }
            .sheet(isPresented: $showingPDFImport) {
                PDFImportView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingPDFImport = false
                })
            }
            .sheet(isPresented: $showingTextImport) {
                TextImportView(onDeckCreated: { deck in
                    onDeckCreated?(deck)
                    showingTextImport = false
                })
            }
        }
    }
}

struct CreateOptionCard: View {
    let icon: String
    let emoji: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: NP.Spacing.lg) {
                Text(emoji)
                    .font(NP.Typography.IconSize.hero)

                VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                    Text(title)
                        .font(NP.Typography.title3)
                        .foregroundColor(NP.Colors.textPrimary)

                    Text(subtitle)
                        .font(NP.Typography.caption1)
                        .foregroundColor(NP.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .padding(NP.Spacing.xxl)
            .background(NP.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
            .npCardShadow()
        }
    }
}
