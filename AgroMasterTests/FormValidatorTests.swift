import XCTest
@testable import AgroMaster

final class FormValidatorTests: XCTestCase {

    // MARK: - isValidName

    func testValidName_withNormalName_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidName("Angelo"))
    }

    func testValidName_withSpacesOnly_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidName("   "))
    }

    func testValidName_withEmptyString_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidName(""))
    }

    func testValidName_withNameContainingSpaces_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidName("John Doe"))
    }

    // MARK: - isValidUsername

    func testValidUsername_withValidUsername_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidUsername("farmer_01"))
    }

    func testValidUsername_tooShort_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidUsername("ab"))
    }

    func testValidUsername_tooLong_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidUsername("abcdefghijklmnop"))  // 16 chars
    }

    func testValidUsername_withSpecialChars_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidUsername("user@name"))
    }

    func testValidUsername_withSpaces_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidUsername("user name"))
    }

    func testValidUsername_exactlyThreeChars_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidUsername("abc"))
    }

    func testValidUsername_exactlyFifteenChars_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidUsername("abcdefghijklmno"))  // 15 chars
    }

    // MARK: - isValidEmail

    func testValidEmail_withStandardEmail_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidEmail("user@example.com"))
    }

    func testValidEmail_withoutAtSign_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidEmail("userexample.com"))
    }

    func testValidEmail_withoutDomain_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidEmail("user@"))
    }

    func testValidEmail_withSubdomain_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidEmail("user@mail.example.com"))
    }

    func testValidEmail_emptyString_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidEmail(""))
    }

    // MARK: - isValidPassword

    func testValidPassword_eightChars_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidPassword("12345678"))
    }

    func testValidPassword_sevenChars_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidPassword("1234567"))
    }

    func testValidPassword_emptyString_returnsFalse() {
        XCTAssertFalse(FormValidator.isValidPassword(""))
    }

    func testValidPassword_longPassword_returnsTrue() {
        XCTAssertTrue(FormValidator.isValidPassword("averylongpassword123"))
    }

    // MARK: - isStrongPassword

    func testStrongPassword_withAllRequirements_returnsTrue() {
        XCTAssertTrue(FormValidator.isStrongPassword("Abcdef1!"))
    }

    func testStrongPassword_missingUppercase_returnsFalse() {
        XCTAssertFalse(FormValidator.isStrongPassword("abcdef1!"))
    }

    func testStrongPassword_missingDigit_returnsFalse() {
        XCTAssertFalse(FormValidator.isStrongPassword("Abcdefg!"))
    }

    func testStrongPassword_missingSpecialChar_returnsFalse() {
        XCTAssertFalse(FormValidator.isStrongPassword("Abcdefg1"))
    }

    func testStrongPassword_tooShort_returnsFalse() {
        XCTAssertFalse(FormValidator.isStrongPassword("Ab1!"))
    }

    func testStrongPassword_missingLowercase_returnsFalse() {
        XCTAssertFalse(FormValidator.isStrongPassword("ABCDEF1!"))
    }

    // MARK: - passwordsMatch

    func testPasswordsMatch_identicalPasswords_returnsTrue() {
        XCTAssertTrue(FormValidator.passwordsMatch("password", "password"))
    }

    func testPasswordsMatch_differentPasswords_returnsFalse() {
        XCTAssertFalse(FormValidator.passwordsMatch("password1", "password2"))
    }

    func testPasswordsMatch_emptyPasswords_returnsTrue() {
        XCTAssertTrue(FormValidator.passwordsMatch("", ""))
    }

    func testPasswordsMatch_caseSensitive_returnsFalse() {
        XCTAssertFalse(FormValidator.passwordsMatch("Password", "password"))
    }

    // MARK: - isUsernameAllowed

    func testUsernameAllowed_normalUsername_returnsTrue() {
        XCTAssertTrue(FormValidator.isUsernameAllowed("farmer"))
    }

    func testUsernameAllowed_admin_returnsFalse() {
        XCTAssertFalse(FormValidator.isUsernameAllowed("admin"))
    }

    func testUsernameAllowed_support_returnsFalse() {
        XCTAssertFalse(FormValidator.isUsernameAllowed("support"))
    }

    func testUsernameAllowed_help_returnsFalse() {
        XCTAssertFalse(FormValidator.isUsernameAllowed("help"))
    }

    func testUsernameAllowed_root_returnsFalse() {
        XCTAssertFalse(FormValidator.isUsernameAllowed("root"))
    }

    func testUsernameAllowed_reservedUppercase_returnsFalse() {
        XCTAssertFalse(FormValidator.isUsernameAllowed("ADMIN"))
    }

    // MARK: - isNotBlank

    func testIsNotBlank_withText_returnsTrue() {
        XCTAssertTrue(FormValidator.isNotBlank("hello"))
    }

    func testIsNotBlank_emptyString_returnsFalse() {
        XCTAssertFalse(FormValidator.isNotBlank(""))
    }

    func testIsNotBlank_spacesOnly_returnsFalse() {
        XCTAssertFalse(FormValidator.isNotBlank("   "))
    }

    func testIsNotBlank_newlinesOnly_returnsFalse() {
        XCTAssertFalse(FormValidator.isNotBlank("\n\n"))
    }

    func testIsNotBlank_tabsAndSpaces_returnsFalse() {
        XCTAssertFalse(FormValidator.isNotBlank("\t  \n"))
    }
}
