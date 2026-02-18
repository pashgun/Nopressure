import SwiftUI
import SwiftData

struct PersonalizationView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedGoal: LearningGoal?
    @Binding var selectedMinutes: Int?
    @Binding var selectedInterests: Set<String>
    @Binding var currentStep: Int
    @State private var userName: String = ""
    let onComplete: () -> Void

    let goals: [(LearningGoal, String, String)] = [
        (.exams, "🎓", "Ace my exams"),
        (.language, "🗣️", "Learn a language"),
        (.professional, "💼", "Professional growth"),
        (.general, "🧠", "General knowledge")
    ]

    let timeOptions: [(Int, String, String)] = [
        (5, "⚡", "Quick learner"),
        (15, "☕", "Steady pace"),
        (30, "📚", "Dedicated"),
        (60, "🚀", "Power user")
    ]

    let interests = [
        "Science", "History", "Languages", "Math",
        "Medicine", "Law", "Art", "Tech",
        "Business", "Music"
    ]

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: NP.Spacing.xxxl) {
                // Title
                VStack(spacing: NP.Spacing.sm) {
                    Text(currentStep == 0 ? "What's your name?" :
                         currentStep == 1 ? "What's your goal?" :
                         currentStep == 2 ? "How much time per day?" :
                         "What interests you?")
                        .font(NP.Typography.title1)
                        .foregroundColor(NP.Colors.textBlack)

                    if currentStep == 3 {
                        Text("Select multiple")
                            .font(NP.Typography.subheadline)
                            .foregroundColor(NP.Colors.textSecondary)
                    }
                }
                .padding(.top, 80) // Intentional large top margin

                Spacer()

                // Content
                if currentStep == 0 {
                    // Name Input
                    VStack(spacing: NP.Spacing.lg) {
                        TextField("Your name", text: $userName)
                            .font(NP.Typography.bodySemibold)
                            .foregroundColor(NP.Colors.textPrimary)
                            .padding(NP.Spacing.xl)
                            .background(NP.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                            .npCardShadow()
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, NP.Spacing.xxxl)

                } else if currentStep == 1 {
                    // Goal Selection
                    VStack(spacing: NP.Spacing.lg) {
                        ForEach(goals, id: \.0) { goal, emoji, title in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedGoal = goal
                                }
                            } label: {
                                HStack(spacing: NP.Spacing.lg) {
                                    Text(emoji)
                                        .font(NP.Typography.IconSize.xxl)

                                    Text(title)
                                        .font(NP.Typography.bodySemibold)
                                        .foregroundColor(NP.Colors.textPrimary)

                                    Spacer()

                                    if selectedGoal == goal {
                                        Image("solar-check-circle-bold")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(NP.Colors.primary)
                                    }
                                }
                                .padding(NP.Spacing.xl)
                                .background(
                                    selectedGoal == goal ? NP.Colors.lightPurple : NP.Colors.surface
                                )
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                                .npCardShadow()
                            }
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxxl)

                } else if currentStep == 2 {
                    // Time Selection
                    VStack(spacing: NP.Spacing.lg) {
                        ForEach(timeOptions, id: \.0) { minutes, emoji, title in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedMinutes = minutes
                                }
                            } label: {
                                HStack(spacing: NP.Spacing.lg) {
                                    Text(emoji)
                                        .font(NP.Typography.IconSize.xxl)

                                    VStack(alignment: .leading, spacing: NP.Spacing.xs) {
                                        Text("\(minutes) min")
                                            .font(NP.Typography.bodySemibold)
                                            .foregroundColor(NP.Colors.textPrimary)

                                        Text(title)
                                            .font(NP.Typography.caption1)
                                            .foregroundColor(NP.Colors.textSecondary)
                                    }

                                    Spacer()

                                    if selectedMinutes == minutes {
                                        Image("solar-check-circle-bold")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(NP.Colors.primary)
                                    }
                                }
                                .padding(NP.Spacing.xl)
                                .background(
                                    selectedMinutes == minutes ? NP.Colors.lightPurple : NP.Colors.surface
                                )
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.lg, style: .continuous))
                                .npCardShadow()
                            }
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxxl)

                } else {
                    // Interests Selection
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: NP.Spacing.md) {
                        ForEach(interests, id: \.self) { interest in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if selectedInterests.contains(interest) {
                                        selectedInterests.remove(interest)
                                    } else {
                                        selectedInterests.insert(interest)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(interest)
                                        .font(NP.Typography.subheadlineSemibold)
                                        .foregroundColor(
                                            selectedInterests.contains(interest) ? .white : NP.Colors.textPrimary
                                        )

                                    if selectedInterests.contains(interest) {
                                        Image(systemName: "checkmark")
                                            .font(NP.Typography.IconSize.xs)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, NP.Spacing.xl)
                                .padding(.vertical, NP.Spacing.md)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedInterests.contains(interest) ? NP.Colors.primary : NP.Colors.surface
                                )
                                .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
                                .shadow(
                                    color: selectedInterests.contains(interest) ? Color.clear : NP.Shadow.cardColor,
                                    radius: NP.Shadow.subtleRadius, x: 0, y: NP.Shadow.subtleY
                                )
                            }
                        }
                    }
                    .padding(.horizontal, NP.Spacing.xxxl)
                }

                Spacer()

                // Continue Button
                Button {
                    if currentStep < 3 {
                        withAnimation {
                            currentStep += 1
                        }
                    } else {
                        // Create user before completing
                        if let goal = selectedGoal, let dailyMinutes = selectedMinutes {
                            _ = UserService.createUser(
                                name: userName.isEmpty ? "Friend" : userName,
                                email: "",
                                goal: goal,
                                dailyMinutes: dailyMinutes,
                                interests: Array(selectedInterests),
                                in: modelContext
                            )
                        }
                        onComplete()
                    }
                } label: {
                    Text(currentStep < 3 ? "Continue" : "Get Started")
                        .npPrimaryButton()
                }
                .padding(.horizontal, NP.Spacing.xxxl)
                .disabled(
                    (currentStep == 0 && userName.isEmpty) ||
                    (currentStep == 1 && selectedGoal == nil) ||
                    (currentStep == 2 && selectedMinutes == nil)
                )
                .opacity(
                    (currentStep == 0 && userName.isEmpty) ||
                    (currentStep == 1 && selectedGoal == nil) ||
                    (currentStep == 2 && selectedMinutes == nil) ? 0.5 : 1.0
                )

                Spacer().frame(height: 60)
            }
        }
    }
}
