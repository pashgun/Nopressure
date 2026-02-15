import SwiftUI

struct SignUpView: View {
    let onComplete: () -> Void

    @State private var isLoading = false
    @State private var selectedMethod: AuthMethod? = nil

    enum AuthMethod {
        case apple
        case google
        case email
    }

    var body: some View {
        ZStack {
            MeshBackground()

            VStack(spacing: NP.Spacing.xxxl) {
                // Title
                VStack(spacing: NP.Spacing.md) {
                    Text("Create Account")
                        .font(NP.Typography.largeTitle)
                        .foregroundColor(NP.Colors.textBlack)

                    Text("Choose how you'd like to sign up")
                        .font(NP.Typography.body)
                        .foregroundColor(NP.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 100)

                Spacer()

                // Auth Buttons
                VStack(spacing: NP.Spacing.lg) {
                    // Apple Sign In
                    AuthButton(
                        icon: "apple.logo",
                        title: "Continue with Apple",
                        isLoading: isLoading && selectedMethod == .apple
                    ) {
                        signIn(with: .apple)
                    }

                    // Google Sign In
                    AuthButton(
                        icon: "g.circle.fill",
                        title: "Continue with Google",
                        isLoading: isLoading && selectedMethod == .google
                    ) {
                        signIn(with: .google)
                    }

                    // Email Sign In
                    AuthButton(
                        icon: "envelope.fill",
                        title: "Continue with Email",
                        isLoading: isLoading && selectedMethod == .email
                    ) {
                        signIn(with: .email)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()

                // Privacy Notice
                Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                    .font(NP.Typography.footnote)
                    .foregroundColor(NP.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
            }
        }
    }

    private func signIn(with method: AuthMethod) {
        selectedMethod = method
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            onComplete()
        }
    }
}

// MARK: - Auth Button Component

private struct AuthButton: View {
    let icon: String
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: NP.Spacing.md) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: NP.Colors.textPrimary))
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: icon)
                        .font(NP.Typography.IconSize.md)
                        .foregroundColor(NP.Colors.textPrimary)
                        .frame(width: 24, height: 24)
                }

                Text(title)
                    .font(NP.Typography.bodySemibold)
                    .foregroundColor(NP.Colors.textPrimary)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal, 20)
        }
        .background(NP.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: NP.Radius.md, style: .continuous))
        .shadow(
            color: NP.Shadow.cardColor,
            radius: NP.Shadow.cardRadius,
            x: NP.Shadow.cardX,
            y: NP.Shadow.cardY
        )
        .disabled(isLoading)
        .opacity(isLoading ? 0.6 : 1.0)
    }
}

// MARK: - Preview

#Preview {
    SignUpView {
        print("Sign up completed")
    }
}
