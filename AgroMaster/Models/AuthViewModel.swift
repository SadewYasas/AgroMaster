import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var lastSignedInEmail: String?
    @Published var currentUserName: String?
    @Published var errorMessage: String = ""

    private var authListener: AuthStateDidChangeListenerHandle?

    init() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            if let uid = user?.uid {
                self?.fetchCurrentUserData(uid: uid)
            }
        }
    }

    // MARK: - Sign In with Email

    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Sign-in error: \(error.localizedDescription)")
                completion(false, error)
            } else {
                self?.user = result?.user
                self?.lastSignedInEmail = email
                self?.fetchCurrentUserData(uid: result?.user.uid)
                completion(true, nil)
            }
        }
    }

    // MARK: - Sign In with Username

    func signInWithUsername(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(false, error)
                    return
                }

                guard let document = snapshot?.documents.first,
                      let email = document.data()["email"] as? String else {
                    completion(false, NSError(
                        domain: "Auth",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Username not found."]
                    ))
                    return
                }

                self?.lastSignedInEmail = email
                self?.signIn(email: email, password: password, completion: completion)
            }
    }

    // MARK: - Fetch User Data

    func fetchCurrentUserData(uid: String?) {
        guard let uid = uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] snapshot, _ in
            if let data = snapshot?.data(), let name = data["name"] as? String {
                DispatchQueue.main.async {
                    self?.currentUserName = name
                }
            }
        }
    }

    // MARK: - Sign Up

    func signUp(name: String, username: String, email: String, password: String, area: String, completion: @escaping (Bool, String?) -> Void) {
        checkUsernameExists(username: username) { exists in
            if exists {
                completion(false, "Username already taken.")
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }

                guard let uid = result?.user.uid else {
                    completion(false, "Failed to create account.")
                    return
                }

                let userData: [String: Any] = [
                    "name": name,
                    "username": username,
                    "email": email,
                    "area": area,
                    "createdAt": Timestamp(date: Date())
                ]

                let db = Firestore.firestore()
                db.collection("users").document(uid).setData(userData) { error in
                    if let error = error {
                        completion(false, error.localizedDescription)
                    } else {
                        self?.user = result?.user
                        completion(true, nil)
                    }
                }
            }
        }
    }

    // MARK: - Check Username

    private func checkUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if error != nil {
                    completion(false)
                    return
                }
                completion((snapshot?.documents.count ?? 0) > 0)
            }
    }

    // MARK: - Helpers

    func getUserName() -> String {
        currentUserName ?? "User"
    }

    // MARK: - Sign Out

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.currentUserName = nil
            KeychainManager.delete()
        } catch {
            print("Sign-out error: \(error.localizedDescription)")
        }
    }
}
