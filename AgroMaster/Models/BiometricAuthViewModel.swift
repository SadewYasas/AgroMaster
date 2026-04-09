import LocalAuthentication
import SwiftUI

struct BiometricError: Identifiable {
    let id = UUID()
    let message: String
}

class BiometricAuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authError: BiometricError?

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Sign in to AgroMaster using Face ID"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticated = true
                    } else {
                        self.authError = BiometricError(
                            message: authenticationError?.localizedDescription ?? "Authentication failed."
                        )
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.authError = BiometricError(
                    message: error?.localizedDescription ?? "Biometric authentication not available."
                )
            }
        }
    }
}
