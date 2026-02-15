import SwiftUI
import SwiftData
import PDFKit
import UniformTypeIdentifiers

struct PDFImportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPDF: URL?
    @State private var showingDocumentPicker = false
    @State private var isProcessing = false
    @State private var processingStage = ProcessingStage.idle
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    private let aiService = AIGenerationService()

    enum ProcessingStage {
        case idle
        case extractingText
        case generatingCards

        var description: String {
            switch self {
            case .idle: return ""
            case .extractingText: return "Reading PDF content..."
            case .generatingCards: return "Generating flashcards..."
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                if showingReview {
                    ReviewGeneratedCardsView(
                        cards: $generatedCards,
                        onSave: { deckName, deckDescription, colorHex, icon in
                            saveDeck(name: deckName, description: deckDescription, color: colorHex, icon: icon)
                        },
                        onCancel: {
                            showingReview = false
                            generatedCards = []
                            selectedPDF = nil
                        }
                    )
                } else {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Instructions
                        VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                            Text("Import PDF")
                                .font(NP.Typography.title1)
                                .foregroundColor(NP.Colors.textBlack)

                            Text("Select a PDF document to convert")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.xl)

                        Spacer()

                        // Preview or Instructions
                        if let pdfURL = selectedPDF {
                            VStack(spacing: NP.Spacing.lg) {
                                // PDF Icon and Name
                                VStack(spacing: NP.Spacing.md) {
                                    Image(systemName: "doc.fill")
                                        .font(NP.Typography.IconSize.illustration)
                                        .foregroundColor(NP.Colors.accent)

                                    Text(pdfURL.lastPathComponent)
                                        .font(NP.Typography.bodySemibold)
                                        .foregroundColor(NP.Colors.textBlack)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(40)
                                .background(NP.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                                .shadow(color: NP.Shadow.cardColor, radius: NP.Shadow.cardRadius, x: NP.Shadow.cardX, y: NP.Shadow.cardY)

                                if !isProcessing {
                                    Button("Choose Different PDF") {
                                        selectedPDF = nil
                                        showingDocumentPicker = true
                                    }
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.primary)
                                }
                            }
                        } else {
                            VStack(spacing: NP.Spacing.xl) {
                                Image(systemName: "doc.badge.plus")
                                    .font(NP.Typography.IconSize.illustration)
                                    .foregroundColor(NP.Colors.accent)

                                Text("No PDF selected")
                                    .font(NP.Typography.bodySemibold)
                                    .foregroundColor(NP.Colors.textBlack)

                                Text("Tap the button below to choose a PDF")
                                    .font(NP.Typography.subheadline)
                                    .foregroundColor(NP.Colors.textSecondary)
                            }
                        }

                        Spacer()

                        // Processing Status
                        if isProcessing {
                            VStack(spacing: NP.Spacing.md) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: NP.Colors.primary))
                                    .scaleEffect(1.5)

                                Text(processingStage.description)
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.textPrimary)
                            }
                            .padding(.vertical, 30)
                        }

                        // Error Message
                        if let error = errorMessage {
                            Text(error)
                                .font(NP.Typography.caption1)
                                .foregroundColor(Color(hex: "#FF453A"))
                                .padding(.horizontal, NP.Spacing.xxl)
                                .multilineTextAlignment(.center)
                        }

                        // Action Button
                        if selectedPDF != nil && !isProcessing {
                            Button {
                                Task {
                                    await processPDF()
                                }
                            } label: {
                                HStack(spacing: NP.Spacing.md) {
                                    Image(systemName: "sparkles")
                                        .font(NP.Typography.IconSize.sm)

                                    Text("Generate Flashcards")
                                        .font(NP.Typography.bodySemibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(NP.Colors.primary)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            }
                            .padding(.horizontal, NP.Spacing.xxl)
                        } else if !isProcessing {
                            Button {
                                showingDocumentPicker = true
                            } label: {
                                HStack(spacing: NP.Spacing.md) {
                                    Image(systemName: "doc.badge.plus")
                                        .font(NP.Typography.IconSize.sm)

                                    Text("Choose PDF")
                                        .font(NP.Typography.bodySemibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(NP.Colors.primary)
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            }
                            .padding(.horizontal, NP.Spacing.xxl)
                        }

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationTitle("PDF Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingReview && !isProcessing {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(NP.Colors.primary)
                    }
                }
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(selectedURL: $selectedPDF)
            }
        }
        .alert("Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text(saveErrorMessage)
        }
    }

    private func processPDF() async {
        guard let pdfURL = selectedPDF else { return }

        isProcessing = true
        errorMessage = nil

        do {
            // Step 1: Extract text from PDF
            processingStage = .extractingText
            let extractedText = try await extractTextFromPDF(url: pdfURL)

            // Step 2: Generate flashcards
            processingStage = .generatingCards
            let cards = try await aiService.generateFlashcards(from: extractedText)

            await MainActor.run {
                generatedCards = cards
                showingReview = true
                isProcessing = false
                processingStage = .idle
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isProcessing = false
                processingStage = .idle
            }
        }
    }

    private func extractTextFromPDF(url: URL) async throws -> String {
        guard let document = PDFDocument(url: url) else {
            throw NSError(domain: "PDFImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF"])
        }

        var allText = ""
        let pageCount = document.pageCount

        for pageIndex in 0..<min(pageCount, 20) { // Limit to first 20 pages
            if let page = document.page(at: pageIndex),
               let pageContent = page.string {
                allText += pageContent + "\n\n"
            }
        }

        guard !allText.isEmpty else {
            throw NSError(domain: "PDFImport", code: 2, userInfo: [NSLocalizedDescriptionKey: "No text found in PDF"])
        }

        return allText
    }

    private func saveDeck(name: String, description: String?, color: String, icon: String) {
        let deck = Deck(
            name: name,
            description: description ?? "",
            colorHex: color,
            icon: icon
        )
        modelContext.insert(deck)

        for card in generatedCards {
            let flashcard = Flashcard(
                front: card.front,
                back: card.back,
                deck: deck
            )
            modelContext.insert(flashcard)
        }

        do {
            try modelContext.save()
            dismiss()
        } catch {
            showSaveError = true
            saveErrorMessage = "Failed to save deck: \(error.localizedDescription)"
        }
    }
}

// MARK: - Document Picker

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedURL: URL?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.selectedURL = url
            }
            parent.dismiss()
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
}

#Preview {
    PDFImportView()
}
