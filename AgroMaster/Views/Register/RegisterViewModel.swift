import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var selectedArea = "Select Area"
    @Published var acceptTerms = false

    @Published var isShowingAreaDialog = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var attemptedRegister = false
    @Published var registrationSuccess = false

    let areas = ["Colombo", "Galle", "Kandy", "Jaffna", "Matara"]

    var isFormValid: Bool {
        FormValidator.isValidName(name) &&
        FormValidator.isValidUsername(username) &&
        FormValidator.isUsernameAllowed(username) &&
        FormValidator.isValidEmail(email) &&
        FormValidator.isStrongPassword(password) &&
        FormValidator.passwordsMatch(password, confirmPassword) &&
        selectedArea != "Select Area" &&
        acceptTerms
    }

    func registerUser(completion: @escaping () -> Void) {
        attemptedRegister = true
        guard isFormValid else { return }

        isLoading = true
        errorMessage = ""

        let db = Firestore.firestore()
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to register: \(error.localizedDescription)"
                        self.isLoading = false
                    }
                    return
                }

                if (snapshot?.documents.count ?? 0) > 0 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Username already taken."
                        self.isLoading = false
                    }
                    return
                }

                Auth.auth().createUser(withEmail: self.email, password: self.password) { result, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.errorMessage = "Failed to register: \(error.localizedDescription)"
                            self.isLoading = false
                        }
                        return
                    }

                    guard let uid = result?.user.uid else {
                        DispatchQueue.main.async {
                            self.errorMessage = "User ID could not be retrieved."
                            self.isLoading = false
                        }
                        return
                    }

                    let userData: [String: Any] = [
                        "name": self.name,
                        "username": self.username,
                        "email": self.email,
                        "area": self.selectedArea,
                        "createdAt": Timestamp()
                    ]

                    db.collection("users").document(uid).setData(userData) { error in
                        DispatchQueue.main.async {
                            self.isLoading = false
                            if let error = error {
                                self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                            } else {
                                self.registrationSuccess = true
                                completion()
                            }
                        }
                    }
                }
            }
    }
}
