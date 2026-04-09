import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var attemptedLogin = false
    @Published var navigateToRegister = false

    var isFormValid: Bool {
        FormValidator.isValidEmail(email) && !password.isEmpty
    }

    func handleLogin(authViewModel: AuthViewModel) {
        attemptedLogin = true
        guard isFormValid else { return }

        isLoading = true
        errorMessage = ""

        authViewModel.signIn(email: email, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    _ = KeychainManager.save(
                        email: self?.email ?? "",
                        password: self?.password ?? ""
                    )
                }
            }
        }
    }
}
