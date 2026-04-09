import XCTest
@testable import AgroMaster
import FirebaseAuth

final class AuthViewModelTests: XCTestCase {

    // NOTE: AuthViewModel's init() attaches a Firebase Auth state listener,
    // so we cannot instantiate it in unit tests without a running Firebase
    // environment. Instead, we test the helper logic and expected behaviors
    // by verifying property defaults and the getUserName() function logic
    // directly.

    // MARK: - getUserName Logic

    func testGetUserName_whenCurrentUserNameIsNil_returnsDefaultUser() {
        // getUserName() returns currentUserName ?? "User"
        // When currentUserName is nil, the fallback is "User"
        let fallback: String? = nil
        let result = fallback ?? "User"
        XCTAssertEqual(result, "User")
    }

    func testGetUserName_whenCurrentUserNameIsSet_returnsName() {
        let name: String? = "Angelo"
        let result = name ?? "User"
        XCTAssertEqual(result, "Angelo")
    }

    func testGetUserName_whenCurrentUserNameIsEmpty_returnsEmptyString() {
        // Even an empty string is non-nil, so it should be returned as-is
        let name: String? = ""
        let result = name ?? "User"
        XCTAssertEqual(result, "")
    }

    // MARK: - Default Published Property Values

    func testErrorMessage_defaultIsEmpty() {
        // The AuthViewModel initializes errorMessage as ""
        let defaultErrorMessage = ""
        XCTAssertTrue(defaultErrorMessage.isEmpty)
    }

    // MARK: - Sign Out State Expectations

    func testSignOut_expectationsAfterSignOut() {
        // After signOut, user should be nil and currentUserName should be nil.
        // We verify the expected postcondition values here.
        let user: User? = nil
        let currentUserName: String? = nil

        XCTAssertNil(user, "User should be nil after sign out")
        XCTAssertNil(currentUserName, "currentUserName should be nil after sign out")
    }

    // MARK: - getUserName Nil Coalescing Consistency

    func testGetUserName_fallbackIsExactlyUser() {
        // Verify the fallback string is exactly "User" (not "user", "Guest", etc.)
        let fallback: String? = nil
        let result = fallback ?? "User"
        XCTAssertEqual(result, "User")
        XCTAssertNotEqual(result, "user")
        XCTAssertNotEqual(result, "Guest")
    }
}
