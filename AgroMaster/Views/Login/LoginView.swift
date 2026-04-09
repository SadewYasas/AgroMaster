import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = LoginViewModel()
    @StateObject private var biometricAuth = BiometricAuthViewModel()
    @State private var showBiometricModal = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    // Logo
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 4)

                        Image(systemName: "leaf.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.primaryGreen)
                    }

                    // Title
                    VStack(spacing: 6) {
                        Text("AgroMaster")
                            .font(.heading1)
                            .foregroundColor(.primaryGreen)

                        Text("PRECISION AGRICULTURE MANAGEMENT")
                            .font(.caption2)
                            .tracking(2)
                            .foregroundColor(.accentBrown)
                    }

                    Spacer().frame(height: 8)

                    // Input group
                    VStack(spacing: 0) {
                        CustomTextField(
                            label: "Email Address",
                            placeholder: "Enter your email",
                            text: $viewModel.email,
                            keyboardType: .emailAddress
                        )
                        .accessibilityIdentifier("emailField")

                        Divider()
                            .padding(.horizontal, 16)

                        CustomSecureField(
                            label: "Password",
                            placeholder: "Enter your password",
                            text: $viewModel.password
                        )
                        .accessibilityIdentifier("passwordField")
                    }
                    .background(Color.surfaceMedium)
                    .cornerRadius(16)
                    .padding(.horizontal, 24)

                    // Validation messages
                    VStack(alignment: .leading, spacing: 4) {
                        if viewModel.attemptedLogin && !FormValidator.isValidEmail(viewModel.email) {
                            validationText("Please enter a valid email address.")
                        }
                        if viewModel.attemptedLogin && viewModel.password.isEmpty {
                            validationText("Password cannot be empty.")
                        }
                        if !viewModel.errorMessage.isEmpty {
                            validationText(viewModel.errorMessage)
                        }
                    }
                    .padding(.horizontal, 24)

                    // Sign In button
                    GradientButton(
                        title: "Sign In",
                        isLoading: viewModel.isLoading
                    ) {
                        viewModel.handleLogin(authViewModel: authViewModel)
                    }
                    .padding(.horizontal, 24)
                    .accessibilityIdentifier("loginButton")

                    // Face ID button
                    if !viewModel.isLoading {
                        GradientButton(
                            title: "Login with Face ID",
                            style: .outlined,
                            icon: "faceid"
                        ) {
                            showBiometricModal = true
                            biometricAuth.authenticate()
                        }
                        .padding(.horizontal, 24)
                        .accessibilityIdentifier("biometricLoginButton")
                    }

                    // Forgot password
                    Button("Forgot Password?") {
                        // TODO: Password reset flow
                    }
                    .font(.bodySmall)
                    .foregroundColor(.accentBrown)

                    // Sign up link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.textSecondary)
                        Button("Sign up") {
                            viewModel.navigateToRegister = true
                        }
                        .foregroundColor(.primaryGreen)
                        .fontWeight(.semibold)
                    }
                    .font(.bodySmall)
                }
            }
            .background(Color.appBackground)
            .navigationDestination(isPresented: $viewModel.navigateToRegister) {
                RegisterView()
                    .accessibilityIdentifier("RegisterView")
            }
            .onReceive(biometricAuth.$isAuthenticated) { isAuthenticated in
                guard isAuthenticated else { return }
                showBiometricModal = false
                if let credentials = KeychainManager.retrieve() {
                    viewModel.isLoading = true
                    authViewModel.signIn(email: credentials.email, password: credentials.password) { _, error in
                        DispatchQueue.main.async {
                            viewModel.isLoading = false
                            if let error = error {
                                viewModel.errorMessage = error.localizedDescription
                            }
                        }
                    }
                } else {
                    viewModel.errorMessage = "No saved credentials found. Please sign in with email first."
                }
            }
            .alert(item: $biometricAuth.authError) { error in
                Alert(
                    title: Text("Authentication Error"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .overlay {
                if showBiometricModal && !biometricAuth.isAuthenticated {
                    biometricOverlay
                }
            }
        }
    }

    // MARK: - Biometric Modal Overlay

    private var biometricOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showBiometricModal = false
                }

            VStack(spacing: 20) {
                Image(systemName: "faceid")
                    .font(.system(size: 48))
                    .foregroundColor(.primaryGreen)

                Text("Face ID")
                    .font(.heading3)
                    .foregroundColor(.textPrimary)

                Text("Sign in to AgroMaster using Face ID")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)

                Button("Cancel") {
                    showBiometricModal = false
                }
                .font(.button)
                .foregroundColor(.textSecondary)
                .padding(.top, 8)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .cornerRadius(32)
            .padding(.horizontal, 40)
        }
    }

    // MARK: - Helpers

    private func validationText(_ message: String) -> some View {
        Text(message)
            .font(.caption2)
            .foregroundColor(.alertRed)
    }
}
