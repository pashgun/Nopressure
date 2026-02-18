import SwiftUI
import SwiftData
import PDFKit

struct AIGenerationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var onDeckCreated: ((Deck) -> Void)?

    // MARK: - Source Selection

    enum InputSource: String, CaseIterable, Identifiable {
        case text = "Text"
        case camera = "Camera"
        case pdf = "PDF"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .text: return "text.alignleft"
            case .camera: return "camera.fill"
            case .pdf: return "doc.fill"
            }
        }

        var description: String {
            switch self {
            case .text: return "Paste or type text"
            case .camera: return "Snap notes or textbook"
            case .pdf: return "Import a PDF document"
            }
        }
    }

    @State private var selectedSource: InputSource = .text

    // MARK: - Text Input

    @State private var inputText = ""
    private let characterLimit = 5000

    // MARK: - Camera Input

    @State private var capturedImage: UIImage?
    @State private var showingCamera = false

    // MARK: - PDF Input

    @State private var selectedPDF: URL?
    @State private var showingDocumentPicker = false

    // MARK: - Processing

    @State private var isProcessing = false
    @State private var processingMessage = ""
    @State private var errorMessage: String?

    // MARK: - Review

    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var showingReview = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    private let ocrService = OCRService()
    private let aiService = AIGenerationService()

    // MARK: - Body

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
                        }
                    )
                } else {
                    VStack(spacing: 0) {
                        // Source Picker
                        sourcePickerSection
                            .padding(.top, NP.Spacing.lg)

                        // Content Area
                        ScrollView {
                            VStack(spacing: NP.Spacing.xxl) {
                                contentForSource
                            }
                            .padding(.top, NP.Spacing.xxl)
                            .padding(.bottom, 140)
                        }

                        Spacer(minLength: 0)

                        // Bottom Action
                        bottomActionSection
                    }
                }
            }
            .navigationTitle("AI Generation")
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
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $capturedImage)
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

    // MARK: - Source Picker

    private var sourcePickerSection: some View {
        HStack(spacing: NP.Spacing.sm) {
            ForEach(InputSource.allCases) { source in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedSource = source
                    }
                } label: {
                    HStack(spacing: NP.Spacing.xs) {
                        Image(systemName: source.icon)
                            .font(NP.Typography.IconSize.xs)

                        Text(source.rawValue)
                            .font(NP.Typography.subheadlineSemibold)
                    }
                    .foregroundColor(selectedSource == source ? .white : NP.Colors.textPrimary)
                    .padding(.horizontal, NP.Spacing.lg)
                    .padding(.vertical, NP.Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: NP.Radius.pill, style: .continuous)
                            .fill(selectedSource == source ? NP.Colors.primary : NP.Colors.surface)
                    )
                    .npSubtleShadow()
                }
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }

    // MARK: - Content per Source

    @ViewBuilder
    private var contentForSource: some View {
        switch selectedSource {
        case .text:
            textInputContent
        case .camera:
            cameraInputContent
        case .pdf:
            pdfInputContent
        }
    }

    // MARK: - Text Input Content

    private var textInputContent: some View {
        VStack(spacing: NP.Spacing.md) {
            VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                Text("Paste or type text")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text("AI will generate flashcards from your content")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, NP.Spacing.xxl)

            TextEditor(text: $inputText)
                .font(NP.Typography.body)
                .foregroundColor(NP.Colors.textPrimary)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(minHeight: 280)
                .padding(NP.Spacing.lg)
                .background(NP.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                .npCardShadow()
                .padding(.horizontal, NP.Spacing.xxl)

            HStack {
                Text("\(inputText.count)/\(characterLimit)")
                    .font(NP.Typography.caption2)
                    .foregroundColor(inputText.count > characterLimit ? NP.Colors.error : NP.Colors.textSecondary)

                Spacer()

                if !inputText.isEmpty {
                    Button("Clear") {
                        inputText = ""
                    }
                    .font(NP.Typography.caption1Semibold)
                    .foregroundColor(NP.Colors.error)
                }
            }
            .padding(.horizontal, NP.Spacing.xxl)

            // Error
            if let error = errorMessage {
                Text(error)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.error)
                    .padding(.horizontal, NP.Spacing.xxl)
            }
        }
    }

    // MARK: - Camera Input Content

    private var cameraInputContent: some View {
        VStack(spacing: NP.Spacing.xxl) {
            VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                Text("Snap & Learn")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text("Take a photo of notes or textbook pages")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, NP.Spacing.xxl)

            if let image = capturedImage {
                VStack(spacing: NP.Spacing.lg) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 350)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                        .npCardShadow()

                    if !isProcessing {
                        Button("Retake Photo") {
                            capturedImage = nil
                            showingCamera = true
                        }
                        .font(NP.Typography.subheadlineSemibold)
                        .foregroundColor(NP.Colors.primary)
                    }
                }
                .padding(.horizontal, NP.Spacing.xxl)
            } else {
                VStack(spacing: NP.Spacing.xl) {
                    ZStack {
                        Circle()
                            .fill(NP.Colors.lightPurple.opacity(0.5))
                            .frame(width: 120, height: 120)

                        Image(systemName: "camera.fill")
                            .font(NP.Typography.IconSize.hero)
                            .foregroundColor(NP.Colors.primary)
                    }

                    Text("No photo taken yet")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(NP.Colors.textBlack)

                    Button {
                        showingCamera = true
                    } label: {
                        HStack(spacing: NP.Spacing.md) {
                            Image(systemName: "camera.fill")
                                .font(NP.Typography.IconSize.sm)
                            Text("Take Photo")
                                .font(NP.Typography.bodySemibold)
                        }
                        .npPrimaryButton()
                    }
                    .padding(.horizontal, NP.Spacing.xxl)
                }
                .padding(.top, NP.Spacing.xxxl)
            }

            if let error = errorMessage {
                Text(error)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.error)
                    .padding(.horizontal, NP.Spacing.xxl)
            }
        }
    }

    // MARK: - PDF Input Content

    private var pdfInputContent: some View {
        VStack(spacing: NP.Spacing.xxl) {
            VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                Text("Import PDF")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text("Select a PDF document to generate flashcards")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, NP.Spacing.xxl)

            if let pdfURL = selectedPDF {
                VStack(spacing: NP.Spacing.lg) {
                    VStack(spacing: NP.Spacing.md) {
                        Image(systemName: "doc.fill")
                            .font(NP.Typography.IconSize.hero)
                            .foregroundColor(NP.Colors.accent)

                        Text(pdfURL.lastPathComponent)
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(NP.Colors.textBlack)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                    }
                    .padding(NP.Spacing.xxxl)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                    .npCardShadow()

                    if !isProcessing {
                        Button("Choose Different PDF") {
                            selectedPDF = nil
                            showingDocumentPicker = true
                        }
                        .font(NP.Typography.subheadlineSemibold)
                        .foregroundColor(NP.Colors.primary)
                    }
                }
                .padding(.horizontal, NP.Spacing.xxl)
            } else {
                VStack(spacing: NP.Spacing.xl) {
                    ZStack {
                        Circle()
                            .fill(NP.Colors.lightOrange.opacity(0.5))
                            .frame(width: 120, height: 120)

                        Image(systemName: "doc.badge.plus")
                            .font(NP.Typography.IconSize.hero)
                            .foregroundColor(NP.Colors.accent)
                    }

                    Text("No PDF selected")
                        .font(NP.Typography.bodySemibold)
                        .foregroundColor(NP.Colors.textBlack)

                    Button {
                        showingDocumentPicker = true
                    } label: {
                        HStack(spacing: NP.Spacing.md) {
                            Image(systemName: "doc.badge.plus")
                                .font(NP.Typography.IconSize.sm)
                            Text("Choose PDF")
                                .font(NP.Typography.bodySemibold)
                        }
                        .npPrimaryButton()
                    }
                    .padding(.horizontal, NP.Spacing.xxl)
                }
                .padding(.top, NP.Spacing.xxxl)
            }

            if let error = errorMessage {
                Text(error)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.error)
                    .padding(.horizontal, NP.Spacing.xxl)
            }
        }
    }

    // MARK: - Bottom Action

    private var bottomActionSection: some View {
        VStack(spacing: 0) {
            if isProcessing {
                VStack(spacing: NP.Spacing.md) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: NP.Colors.primary))
                        .scaleEffect(1.3)

                    Text(processingMessage)
                        .font(NP.Typography.subheadlineSemibold)
                        .foregroundColor(NP.Colors.textPrimary)
                }
                .padding(.vertical, NP.Spacing.xxl)
            } else if canGenerate {
                Button {
                    Task { await generate() }
                } label: {
                    HStack(spacing: NP.Spacing.md) {
                        Image(systemName: "sparkles")
                            .font(NP.Typography.IconSize.sm)
                        Text("Generate Flashcards")
                            .font(NP.Typography.bodySemibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: NP.Size.buttonHeight)
                    .background(NP.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.bottom, NP.Spacing.xxxl)
            }
        }
        .background(
            NP.Colors.background.opacity(0.95)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    // MARK: - Logic

    private var canGenerate: Bool {
        switch selectedSource {
        case .text:
            return !inputText.isEmpty && inputText.count <= characterLimit
        case .camera:
            return capturedImage != nil
        case .pdf:
            return selectedPDF != nil
        }
    }

    private func generate() async {
        isProcessing = true
        errorMessage = nil

        do {
            let text: String

            switch selectedSource {
            case .text:
                text = inputText

            case .camera:
                guard let image = capturedImage else { return }
                processingMessage = "Reading text from image..."
                text = try await ocrService.extractText(from: image)

            case .pdf:
                guard let pdfURL = selectedPDF else { return }
                processingMessage = "Reading PDF content..."
                text = try await extractTextFromPDF(url: pdfURL)
            }

            processingMessage = "Generating flashcards..."
            let cards = try await aiService.generateFlashcards(from: text)

            await MainActor.run {
                generatedCards = cards
                showingReview = true
                isProcessing = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isProcessing = false
            }
        }
    }

    private func extractTextFromPDF(url: URL) async throws -> String {
        guard let document = PDFDocument(url: url) else {
            throw NSError(domain: "PDFImport", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to load PDF"])
        }

        var allText = ""
        for pageIndex in 0..<min(document.pageCount, 20) {
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
            onDeckCreated?(deck)
            dismiss()
        } catch {
            showSaveError = true
            saveErrorMessage = "Failed to save deck: \(error.localizedDescription)"
        }
    }
}

#Preview {
    AIGenerationView(onDeckCreated: nil)
}
