import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.primaryGreen)
                }
                .padding(.top, 10)

                Text("Create Account")
                    .font(.heading2)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                // Name
                VStack(alignment: .leading, spacing: 4) {
                    inputField {
                        CustomTextField(label: "Full Name", placeholder: "Enter your name", text: $viewModel.name)
                    }
                    if viewModel.attemptedRegister && !FormValidator.isValidName(viewModel.name) {
                        validationMessage("Name cannot be empty.")
                    }
                }

                // Username
                VStack(alignment: .leading, spacing: 4) {
                    inputField {
                        CustomTextField(label: "Username", placeholder: "Choose a username", text: $viewModel.username)
                    }
                    if viewModel.attemptedRegister {
                        if !FormValidator.isValidUsername(viewModel.username) {
                            validationMessage("Username must be 3-15 characters, alphanumeric or underscore.")
                        } else if !FormValidator.isUsernameAllowed(viewModel.username) {
                            validationMessage("This username is reserved. Please choose another.")
                        }
                    }
                }

                // Email
                VStack(alignment: .leading, spacing: 4) {
                    inputField {
                        CustomTextField(label: "Email Address", placeholder: "Enter your email", text: $viewModel.email, keyboardType: .emailAddress)
                    }
                    if viewModel.attemptedRegister && !FormValidator.isValidEmail(viewModel.email) {
                        validationMessage("Please enter a valid email address.")
                    }
                }

                // Password
                VStack(alignment: .leading, spacing: 4) {
                    inputField {
                        CustomSecureField(label: "Password", placeholder: "Create a password", text: $viewModel.password)
                    }
                    .accessibilityIdentifier("PwdField")
                    if viewModel.attemptedRegister && !FormValidator.isStrongPassword(viewModel.password) {
                        validationMessage("Password must be 8+ chars with upper/lowercase, number & special character.")
                    }
                }

                // Confirm Password
                VStack(alignment: .leading, spacing: 4) {
                    inputField {
                        CustomSecureField(label: "Confirm Password", placeholder: "Re-enter your password", text: $viewModel.confirmPassword)
                    }
                    .accessibilityIdentifier("ConfField")
                    if viewModel.attemptedRegister && !FormValidator.passwordsMatch(viewModel.password, viewModel.confirmPassword) {
                        validationMessage("Passwords do not match.")
                    }
                }

                // Area selector
                Button {
                    viewModel.isShowingAreaDialog = true
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AREA")
                                .font(.label)
                                .tracking(1.2)
                                .foregroundColor(.textSecondary)
                            Text(viewModel.selectedArea)
                                .font(.bodyRegular)
                                .foregroundColor(viewModel.selectedArea == "Select Area" ? .textSecondary.opacity(0.6) : .textPrimary)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.textSecondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.surfaceMedium)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .confirmationDialog("Select Your Area", isPresented: $viewModel.isShowingAreaDialog) {
                    ForEach(viewModel.areas, id: \.self) { area in
                        Button(area) {
                            viewModel.selectedArea = area
                        }
                    }
                }

                if viewModel.attemptedRegister && viewModel.selectedArea == "Select Area" {
                    validationMessage("Please select an area.")
                }

                // Terms
                HStack(alignment: .top, spacing: 10) {
                    Button {
                        viewModel.acceptTerms.toggle()
                    } label: {
                        Image(systemName: viewModel.acceptTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(.primaryGreen)
                            .font(.title3)
                    }

                    (Text("I accept the ") +
                     Text("Terms").underline().foregroundColor(.primaryGreen) +
                     Text(" and ") +
                     Text("Privacy Policy").underline().foregroundColor(.primaryGreen))
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                if viewModel.attemptedRegister && !viewModel.acceptTerms {
                    validationMessage("You must accept the terms and privacy policy.")
                }

                // Error message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.caption2)
                        .foregroundColor(.alertRed)
                        .padding(.horizontal, 24)
                }

                // Sign up button
                GradientButton(
                    title: "Sign Up",
                    isLoading: viewModel.isLoading
                ) {
                    viewModel.registerUser {
                        dismiss()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .accessibilityIdentifier("RegisterButton")

                // Login link
                HStack(spacing: 4) {
                    Text("Already a member?")
                        .foregroundColor(.textSecondary)
                    Button("Login") {
                        dismiss()
                    }
                    .foregroundColor(.primaryGreen)
                    .fontWeight(.semibold)
                }
                .font(.bodySmall)
                .padding(.bottom, 20)
            }
            .padding(.top)
        }
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.textPrimary)
                }
            }
        }
    }

    // MARK: - Helpers

    private func inputField<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .background(Color.surfaceMedium)
            .cornerRadius(16)
            .padding(.horizontal, 24)
    }

    private func validationMessage(_ message: String) -> some View {
        Text(message)
            .font(.caption2)
            .foregroundColor(.alertRed)
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
