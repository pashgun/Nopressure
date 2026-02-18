import SwiftUI

enum StudyMode: String, CaseIterable, Identifiable {
    case flashcard = "Flashcard"
    case quiz = "Quiz"
    case write = "Write"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .flashcard: return "rectangle.stack.fill"
        case .quiz: return "list.bullet.rectangle.fill"
        case .write: return "pencil.line"
        }
    }

    var description: String {
        switch self {
        case .flashcard: return "Flip cards to learn"
        case .quiz: return "Multiple choice questions"
        case .write: return "Type your answers"
        }
    }
}

struct StudyModeSelector: View {
    @Binding var selectedMode: StudyMode

    var body: some View {
        VStack(spacing: NP.Spacing.md) {
            Text("Study Mode")
                .font(NP.Typography.subheadlineSemibold)
                .foregroundColor(NP.Colors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: NP.Spacing.md) {
                ForEach(StudyMode.allCases) { mode in
                    ModeButton(
                        mode: mode,
                        isSelected: selectedMode == mode
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedMode = mode
                        }
                    }
                }
            }
        }
        .padding(.horizontal, NP.Spacing.xxl)
    }
}

struct ModeButton: View {
    let mode: StudyMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: NP.Spacing.sm) {
                Image(systemName: mode.icon)
                    .font(NP.Typography.IconSize.md)
                    .foregroundColor(isSelected ? .white : NP.Colors.textSecondary)

                Text(mode.rawValue)
                    .font(NP.Typography.caption1)
                    .foregroundColor(isSelected ? .white : NP.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, NP.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: NP.Radius.md)
                    .fill(isSelected ? NP.Colors.primary : NP.Colors.surface)
                    .shadow(
                        color: isSelected ? Color.clear : NP.Shadow.cardColor,
                        radius: NP.Shadow.subtleRadius, x: 0, y: NP.Shadow.subtleY
                    )
            )
        }
    }
}

#Preview {
    @Previewable @State var mode = StudyMode.flashcard

    return ZStack {
        MeshBackground()

        VStack {
            StudyModeSelector(selectedMode: $mode)
            Spacer()
        }
        .padding(.top, 100)
    }
}
