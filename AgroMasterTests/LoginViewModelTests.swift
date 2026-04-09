import XCTest
@testable import AgroMaster

final class LoginViewModelTests: XCTestCase {

    private var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial State

    func testInitialState_emailIsEmpty() {
        XCTAssertEqual(viewModel.email, "")
    }

    func testInitialState_passwordIsEmpty() {
        XCTAssertEqual(viewModel.password, "")
    }

    func testInitialState_errorMessageIsEmpty() {
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testInitialState_isLoadingIsFalse() {
        XCTAssertFalse(viewModel.isLoading)
    }

    func testInitialState_attemptedLoginIsFalse() {
        XCTAssertFalse(viewModel.attemptedLogin)
    }

    func testInitialState_navigateToRegisterIsFalse() {
        XCTAssertFalse(viewModel.navigateToRegister)
    }

    // MARK: - isFormValid

    func testIsFormValid_withEmptyEmail_returnsFalse() {
        viewModel.email = ""
        viewModel.password = "password123"
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValid_withInvalidEmail_returnsFalse() {
        viewModel.email = "notanemail"
        viewModel.password = "password123"
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValid_withEmptyPassword_returnsFalse() {
        viewModel.email = "user@example.com"
        viewModel.password = ""
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValid_withValidEmailAndPassword_returnsTrue() {
        viewModel.email = "user@example.com"
        viewModel.password = "password123"
        XCTAssertTrue(viewModel.isFormValid)
    }

    func testIsFormValid_withEmailMissingDomain_returnsFalse() {
        viewModel.email = "user@"
        viewModel.password = "password123"
        XCTAssertFalse(viewModel.isFormValid)
    }

    func testIsFormValid_withBothEmpty_returnsFalse() {
        viewModel.email = ""
        viewModel.password = ""
        XCTAssertFalse(viewModel.isFormValid)
    }

    // MARK: - Property Mutations

    func testSettingNavigateToRegister_changesValue() {
        viewModel.navigateToRegister = true
        XCTAssertTrue(viewModel.navigateToRegister)
    }

    func testSettingErrorMessage_changesValue() {
        viewModel.errorMessage = "Invalid credentials"
        XCTAssertEqual(viewModel.errorMessage, "Invalid credentials")
    }

    func testSettingAttemptedLogin_changesValue() {
        viewModel.attemptedLogin = true
        XCTAssertTrue(viewModel.attemptedLogin)
    }
}
