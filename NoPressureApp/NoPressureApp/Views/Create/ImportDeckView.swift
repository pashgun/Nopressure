import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ImportDeckView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var onDeckCreated: ((Deck) -> Void)?

    enum ImportSource: String, CaseIterable, Identifiable {
        case anki = "Anki"
        case csv = "CSV"
        case googleSheets = "Google Sheets"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .anki: return "square.stack.3d.up.fill"
            case .csv: return "tablecells"
            case .googleSheets: return "doc.text"
            }
        }

        var description: String {
            switch self {
            case .anki: return "Import .apkg or .txt from Anki"
            case .csv: return "Import cards from a CSV file"
            case .googleSheets: return "Paste a Google Sheets link"
            }
        }

        var emoji: String {
            switch self {
            case .anki: return "🃏"
            case .csv: return "📊"
            case .googleSheets: return "📗"
            }
        }
    }

    @State private var selectedSource: ImportSource?
    @State private var showingFilePicker = false
    @State private var googleSheetsURL = ""
    @State private var isProcessing = false
    @State private var processingMessage = ""
    @State private var errorMessage: String?
    @State private var importedCards: [CardDraft] = []
    @State private var deckName = ""
    @State private var showingReviewStep = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    var body: some View {
        NavigationStack {
            ZStack {
                MeshBackground()

                if showingReviewStep {
                    importReviewView
                } else if let source = selectedSource {
                    sourceDetailView(for: source)
                } else {
                    sourceSelectionView
                }
            }
            .navigationTitle("Import Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if showingReviewStep {
                            showingReviewStep = false
                        } else if selectedSource != nil {
                            selectedSource = nil
                            errorMessage = nil
                        } else {
                            dismiss()
                        }
                    } label: {
                        if selectedSource != nil || showingReviewStep {
                            HStack(spacing: NP.Spacing.xs) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(NP.Colors.primary)
                        } else {
                            Text("Cancel")
                                .foregroundColor(NP.Colors.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingFilePicker) {
                filePickerForSource
            }
        }
        .alert("Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text(saveErrorMessage)
        }
    }

    // MARK: - Source Selection

    private var sourceSelectionView: some View {
        VStack(spacing: NP.Spacing.xxl) {
            VStack(spacing: NP.Spacing.sm) {
                Text("Choose Source")
                    .font(NP.Typography.title1)
                    .foregroundColor(NP.Colors.textBlack)

                Text("Select where to import your cards from")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .padding(.top, NP.Spacing.xxxl)

            VStack(spacing: NP.Spacing.lg) {
                ForEach(ImportSource.allCases) { source in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSource = source
                        }
                    } label: {
                        HStack(spacing: NP.Spacing.lg) {
                            ZStack {
                                Circle()
                                    .fill(NP.Colors.lightPurple.opacity(0.5))
                                    .frame(width: 52, height: 52)

                                Text(source.emoji)
                                    .font(.system(size: 26))
                            }

                            VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                                Text(source.rawValue)
                                    .font(NP.Typography.title3)
                                    .foregroundColor(NP.Colors.textPrimary)

                                Text(source.description)
                                    .font(NP.Typography.caption1)
                                    .foregroundColor(NP.Colors.textSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(NP.Typography.IconSize.sm)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                        .padding(NP.Spacing.xl)
                        .background(NP.Colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                        .npCardShadow()
                    }
                }
            }
            .padding(.horizontal, NP.Spacing.xxl)

            Spacer()
        }
    }

    // MARK: - Source Detail View

    @ViewBuilder
    private func sourceDetailView(for source: ImportSource) -> some View {
        switch source {
        case .anki:
            fileImportView(
                title: "Import from Anki",
                subtitle: "Select a .txt export from Anki (tab-separated)",
                buttonTitle: "Choose Anki Export",
                icon: "square.stack.3d.up.fill"
            )
        case .csv:
            fileImportView(
                title: "Import CSV",
                subtitle: "Format: front,back (one card per row)",
                buttonTitle: "Choose CSV File",
                icon: "tablecells"
            )
        case .googleSheets:
            googleSheetsView
        }
    }

    // MARK: - File Import View

    private func fileImportView(title: String, subtitle: String, buttonTitle: String, icon: String) -> some View {
        VStack(spacing: NP.Spacing.xxl) {
            VStack(spacing: NP.Spacing.sm) {
                Text(title)
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text(subtitle)
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, NP.Spacing.xxxl)

            Spacer()

            VStack(spacing: NP.Spacing.xl) {
                ZStack {
                    Circle()
                        .fill(NP.Colors.lightPurple.opacity(0.4))
                        .frame(width: 120, height: 120)

                    Image(systemName: icon)
                        .font(NP.Typography.IconSize.hero)
                        .foregroundColor(NP.Colors.primary)
                }

                if isProcessing {
                    VStack(spacing: NP.Spacing.md) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: NP.Colors.primary))
                            .scaleEffect(1.3)
                        Text(processingMessage)
                            .font(NP.Typography.subheadline)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                } else {
                    Button {
                        showingFilePicker = true
                    } label: {
                        HStack(spacing: NP.Spacing.md) {
                            Image(systemName: "doc.badge.plus")
                                .font(NP.Typography.IconSize.sm)
                            Text(buttonTitle)
                                .font(NP.Typography.bodySemibold)
                        }
                        .npPrimaryButton()
                    }
                    .padding(.horizontal, NP.Spacing.xxl)
                }
            }

            if let error = errorMessage {
                Text(error)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.error)
                    .padding(.horizontal, NP.Spacing.xxl)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
    }

    // MARK: - Google Sheets View

    private var googleSheetsView: some View {
        VStack(spacing: NP.Spacing.xxl) {
            VStack(spacing: NP.Spacing.sm) {
                Text("Google Sheets")
                    .font(NP.Typography.title2)
                    .foregroundColor(NP.Colors.textBlack)

                Text("Paste a published Google Sheets CSV link")
                    .font(NP.Typography.subheadline)
                    .foregroundColor(NP.Colors.textSecondary)
            }
            .padding(.top, NP.Spacing.xxxl)

            VStack(alignment: .leading, spacing: NP.Spacing.md) {
                Text("Sheets URL")
                    .font(NP.Typography.subheadlineSemibold)
                    .foregroundColor(NP.Colors.textSecondary)

                TextField("https://docs.google.com/spreadsheets/...", text: $googleSheetsURL)
                    .font(NP.Typography.body)
                    .foregroundColor(NP.Colors.textPrimary)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .padding(NP.Spacing.lg)
                    .background(NP.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                    .npCardShadow()

                Text("Publish your sheet as CSV first:\nFile → Share → Publish to web → CSV")
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.textSecondary)
                    .padding(.top, NP.Spacing.xs)
            }
            .padding(.horizontal, NP.Spacing.xxl)

            if let error = errorMessage {
                Text(error)
                    .font(NP.Typography.caption1)
                    .foregroundColor(NP.Colors.error)
                    .padding(.horizontal, NP.Spacing.xxl)
            }

            Spacer()

            if isProcessing {
                VStack(spacing: NP.Spacing.md) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: NP.Colors.primary))
                    Text(processingMessage)
                        .font(NP.Typography.subheadline)
                        .foregroundColor(NP.Colors.textSecondary)
                }
                .padding(.bottom, NP.Spacing.xxxl)
            } else {
                Button {
                    Task { await importFromGoogleSheets() }
                } label: {
                    HStack(spacing: NP.Spacing.md) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(NP.Typography.IconSize.sm)
                        Text("Import from Sheets")
                            .font(NP.Typography.bodySemibold)
                    }
                    .npPrimaryButton()
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .padding(.bottom, NP.Spacing.xxxl)
                .disabled(googleSheetsURL.isEmpty)
                .opacity(googleSheetsURL.isEmpty ? 0.5 : 1)
            }
        }
    }

    // MARK: - Import Review

    private var importReviewView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: NP.Spacing.xxl) {
                    // Header
                    VStack(spacing: NP.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(NP.Colors.lightPurple)
                                .frame(width: 80, height: 80)

                            Image("solar-check-circle-bold")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .foregroundColor(NP.Colors.primary)
                        }

                        Text("Found \(importedCards.count) cards")
                            .font(NP.Typography.title1)
                            .foregroundColor(NP.Colors.textBlack)
                    }
                    .padding(.top, NP.Spacing.xxl)

                    // Deck Name
                    VStack(alignment: .leading, spacing: NP.Spacing.md) {
                        Text("Deck Name")
                            .font(NP.Typography.subheadlineSemibold)
                            .foregroundColor(NP.Colors.textSecondary)

                        TextField("Enter deck name", text: $deckName)
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(NP.Colors.textPrimary)
                            .padding(NP.Spacing.lg)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            .npCardShadow()
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    // Cards Preview
                    VStack(alignment: .leading, spacing: NP.Spacing.lg) {
                        Text("Preview (\(min(importedCards.count, 5)) of \(importedCards.count))")
                            .font(NP.Typography.title2)
                            .foregroundColor(NP.Colors.textBlack)

                        ForEach(Array(importedCards.prefix(5).enumerated()), id: \.element.id) { index, card in
                            VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                                Text("Card \(index + 1)")
                                    .font(NP.Typography.caption1Semibold)
                                    .foregroundColor(NP.Colors.textSecondary)

                                Text(card.front)
                                    .font(NP.Typography.bodySemibold)
                                    .foregroundColor(NP.Colors.textBlack)
                                    .lineLimit(2)

                                Text(card.back)
                                    .font(NP.Typography.body)
                                    .foregroundColor(NP.Colors.textPrimary)
                                    .lineLimit(2)
                            }
                            .padding(NP.Spacing.lg)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                            .npCardShadow()
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxl)

                    Spacer(minLength: 120)
                }
            }

            // Save button
            VStack {
                Button {
                    saveImportedDeck()
                } label: {
                    HStack(spacing: NP.Spacing.md) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(NP.Typography.IconSize.sm)
                        Text("Save Deck (\(importedCards.count) cards)")
                            .font(NP.Typography.bodySemibold)
                    }
                    .npPrimaryButton()
                }
                .padding(.horizontal, NP.Spacing.xxl)
                .disabled(deckName.isEmpty || importedCards.isEmpty)
                .opacity(deckName.isEmpty ? 0.5 : 1)
            }
            .padding(.bottom, NP.Spacing.xxxl)
            .background(
                NP.Colors.background.opacity(0.95)
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }

    // MARK: - File Picker

    @ViewBuilder
    private var filePickerForSource: some View {
        switch selectedSource {
        case .anki:
            DocumentPicker(selectedURL: Binding(
                get: { nil },
                set: { url in
                    if let url = url {
                        Task { await importFile(url: url, source: .anki) }
                    }
                }
            ))
        case .csv:
            DocumentPicker(selectedURL: Binding(
                get: { nil },
                set: { url in
                    if let url = url {
                        Task { await importFile(url: url, source: .csv) }
                    }
                }
            ))
        default:
            EmptyView()
        }
    }

    // MARK: - Import Logic

    private func importFile(url: URL, source: ImportSource) async {
        await MainActor.run {
            isProcessing = true
            processingMessage = "Reading file..."
            errorMessage = nil
        }

        do {
            let data = try Data(contentsOf: url)
            guard let content = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "Import", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not read file as text"])
            }

            let cards = parseCSVContent(content, separator: source == .anki ? "\t" : ",")

            await MainActor.run {
                importedCards = cards
                deckName = url.deletingPathExtension().lastPathComponent
                isProcessing = false
                if cards.isEmpty {
                    errorMessage = "No valid cards found. Check the file format."
                } else {
                    showingReviewStep = true
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Failed to import: \(error.localizedDescription)"
                isProcessing = false
            }
        }
    }

    private func importFromGoogleSheets() async {
        guard !googleSheetsURL.isEmpty else { return }

        await MainActor.run {
            isProcessing = true
            processingMessage = "Downloading from Google Sheets..."
            errorMessage = nil
        }

        // Convert share URL to CSV export URL
        var csvURL = googleSheetsURL
        if csvURL.contains("/edit") {
            csvURL = csvURL.replacingOccurrences(of: "/edit.*", with: "/export?format=csv", options: .regularExpression)
        } else if csvURL.contains("/pub") {
            if !csvURL.contains("output=csv") {
                csvURL += (csvURL.contains("?") ? "&" : "?") + "output=csv"
            }
        }

        guard let url = URL(string: csvURL) else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isProcessing = false
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let content = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "Import", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not read response as text"])
            }

            let cards = parseCSVContent(content, separator: ",")

            await MainActor.run {
                importedCards = cards
                deckName = "Google Sheets Import"
                isProcessing = false
                if cards.isEmpty {
                    errorMessage = "No valid cards found. Make sure your sheet has two columns (front, back)."
                } else {
                    showingReviewStep = true
                }
            }
        } catch {
            await MainActor.run {
                errorMessage = "Download failed: \(error.localizedDescription)"
                isProcessing = false
            }
        }
    }

    private func parseCSVContent(_ content: String, separator: String) -> [CardDraft] {
        var cards: [CardDraft] = []
        let lines = content.components(separatedBy: .newlines)

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }

            let parts = trimmed.components(separatedBy: separator)
            guard parts.count >= 2 else { continue }

            let front = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            let back = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))

            guard !front.isEmpty, !back.isEmpty else { continue }

            // Skip header rows
            let lowerFront = front.lowercased()
            if lowerFront == "front" || lowerFront == "question" || lowerFront == "term" { continue }

            var draft = CardDraft()
            draft.front = front
            draft.back = back
            cards.append(draft)
        }

        return cards
    }

    private func saveImportedDeck() {
        let deck = Deck(
            name: deckName,
            description: "Imported from \(selectedSource?.rawValue ?? "file")",
            colorHex: "#5533FF",
            icon: "square.stack.3d.up.fill"
        )
        modelContext.insert(deck)

        for card in importedCards {
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
            saveErrorMessage = "Failed to save: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ImportDeckView(onDeckCreated: nil)
}
