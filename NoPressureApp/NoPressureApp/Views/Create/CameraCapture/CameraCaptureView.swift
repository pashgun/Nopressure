import SwiftUI
import SwiftData
import UIKit

struct CameraCaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var capturedImage: UIImage?
    @State private var showingCamera = false
    @State private var isProcessing = false
    @State private var processingStage = ProcessingStage.idle
    @State private var generatedCards: [GeneratedFlashcard] = []
    @State private var errorMessage: String?
    @State private var showingReview = false
    @State private var showSaveError = false
    @State private var saveErrorMessage = ""

    private let ocrService = OCRService()
    private let aiService = AIGenerationService()

    enum ProcessingStage {
        case idle
        case extractingText
        case generatingCards

        var description: String {
            switch self {
            case .idle: return ""
            case .extractingText: return "Reading text from image..."
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
                            capturedImage = nil
                        }
                    )
                } else {
                    VStack(spacing: NP.Spacing.xxl) {
                        // Instructions
                        VStack(alignment: .leading, spacing: NP.Spacing.sm) {
                            Text("Snap & Learn")
                                .font(NP.Typography.title1)
                                .foregroundColor(NP.Colors.textBlack)

                            Text("Take a photo of notes or textbooks")
                                .font(NP.Typography.subheadline)
                                .foregroundColor(NP.Colors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, NP.Spacing.xxl)
                        .padding(.top, NP.Spacing.xl)

                        Spacer()

                        // Preview or Instructions
                        if let image = capturedImage {
                            VStack(spacing: NP.Spacing.lg) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 400)
                                    .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                                    .shadow(color: NP.Shadow.cardColor, radius: NP.Shadow.cardRadius, x: NP.Shadow.cardX, y: NP.Shadow.cardY)

                                if !isProcessing {
                                    Button("Retake Photo") {
                                        capturedImage = nil
                                        showingCamera = true
                                    }
                                    .font(NP.Typography.subheadlineSemibold)
                                    .foregroundColor(NP.Colors.primary)
                                }
                            }
                        } else {
                            VStack(spacing: NP.Spacing.xl) {
                                Image(systemName: "camera.fill")
                                    .font(NP.Typography.IconSize.illustration)
                                    .foregroundColor(NP.Colors.primary)

                                Text("No photo taken yet")
                                    .font(NP.Typography.bodySemibold)
                                    .foregroundColor(NP.Colors.textBlack)

                                Text("Tap the button below to start")
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
                        if capturedImage != nil && !isProcessing {
                            Button {
                                Task {
                                    await processImage()
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
                                showingCamera = true
                            } label: {
                                HStack(spacing: NP.Spacing.md) {
                                    Image(systemName: "camera.fill")
                                        .font(NP.Typography.IconSize.sm)

                                    Text("Take Photo")
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
            .navigationTitle("Camera Capture")
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
        }
        .alert("Error", isPresented: $showSaveError) {
            Button("OK") { }
        } message: {
            Text(saveErrorMessage)
        }
    }

    private func processImage() async {
        guard let image = capturedImage else { return }

        isProcessing = true
        errorMessage = nil

        do {
            // Step 1: Extract text with OCR
            processingStage = .extractingText
            let extractedText = try await ocrService.extractText(from: image)

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

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraCaptureView()
}
