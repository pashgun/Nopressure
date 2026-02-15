import UIKit
import Vision

/// Service for extracting text from images using Apple's Vision framework
actor OCRService {
    enum OCRError: LocalizedError {
        case imageProcessingFailed
        case noTextFound
        case visionRequestFailed(Error)

        var errorDescription: String? {
            switch self {
            case .imageProcessingFailed:
                return "Failed to process image"
            case .noTextFound:
                return "No text found in image"
            case .visionRequestFailed(let error):
                return "OCR failed: \(error.localizedDescription)"
            }
        }
    }

    /// Extract text from an image
    /// - Parameter image: UIImage to extract text from
    /// - Returns: Extracted text as a single string
    func extractText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw OCRError.imageProcessingFailed
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: OCRError.visionRequestFailed(error))
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }

                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }

                guard !recognizedStrings.isEmpty else {
                    continuation.resume(throwing: OCRError.noTextFound)
                    return
                }

                let fullText = recognizedStrings.joined(separator: "\n")
                continuation.resume(returning: fullText)
            }

            // Use accurate recognition level for better results
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: OCRError.visionRequestFailed(error))
            }
        }
    }

    /// Extract text from multiple images and concatenate
    /// - Parameter images: Array of UIImages
    /// - Returns: Combined extracted text
    func extractText(from images: [UIImage]) async throws -> String {
        var allText: [String] = []

        for image in images {
            do {
                let text = try await extractText(from: image)
                allText.append(text)
            } catch {
                // Continue with other images even if one fails
                print("Failed to extract text from image: \(error.localizedDescription)")
            }
        }

        guard !allText.isEmpty else {
            throw OCRError.noTextFound
        }

        return allText.joined(separator: "\n\n")
    }
}
