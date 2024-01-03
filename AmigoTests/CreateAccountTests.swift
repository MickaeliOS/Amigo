//
//  CreateAccountTests.swift
//  CreateAccountTests
//
//  Created by Mickaël Horn on 19/12/2023.
//

import XCTest
@testable import Amigo

@MainActor
final class CreateAccountTests: XCTestCase {

    // MARK: - PROPERTIES
    private var sut: CreateAccountViewModel!
    private var firebaseAuthService: MockFirebaseAuthService!
    private var firestoreService: MockFirestoreService!

    // MARK: - SETUP
    override func setUp() {
        firebaseAuthService = MockFirebaseAuthService()
        firestoreService = MockFirestoreService()
        sut = CreateAccountViewModel(firebaseAuthService: firebaseAuthService, firestoreService: firestoreService)
    }

    // MARK: - PRIVATE FUNCTIONS
    private func setupUser(email: String = "mail@mail.com",
                           password: String = "pmpmpmP0",
                           confirmPassword: String = "pmpmpmP0",
                           lastname: String = "lastName",
                           firstname: String = "firstname") {
        sut.email = email
        sut.password = password
        sut.confirmPassword = confirmPassword
        sut.lastname = lastname
        sut.firstname = firstname
    }

    // MARK: - FIREBASE AUTH TESTS
    func testGivenBadEmail_WhenCreatingAccount_ThenBadEmailErrorOccurs() async {
        setupUser(email: "mail@mail")

        await sut.createUser()

        XCTAssertFalse(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
        XCTAssertEqual(sut.errorMessage, "Badly formatted email, please provide a correct one.")
    }

    func testGivenBadConfirmationPassword_WhenCreatingAccount_ThenBadConfirmationPasswordErrorOccurs() async {
        setupUser(confirmPassword: "pmpmpmP00")

        await sut.createUser()

        XCTAssertFalse(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
        XCTAssertEqual(sut.errorMessage, "Passwords must be equals.")
    }

    func testGivenWeakPassword_WhenCreatingAccount_ThenWeakPasswordErrorOccurs() async {
        setupUser(password: "weakPassword")

        await sut.createUser()

        XCTAssertFalse(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
        XCTAssertEqual(sut.errorMessage, """
                Your password is too weak. It must be : \n
                - At least 7 characters long \n
                - At least one uppercase letter \n
                - At least one number
                """)
    }

    func testGivenAnEmptyField_WhenCreatingAccount_ThenEmptyFieldsErrorOccurs() async {
        setupUser(email: "")

        await sut.createUser()

        XCTAssertEqual(sut.errorMessage, "All fields must be filled.")
        XCTAssertFalse(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
    }

    func testGivenEmailAlreadyInUse_WhenCreatingAccount_ThenEmailAlreadyInUseErrorOccurs() async {
        setupUser()
        firebaseAuthService.error = FirebaseAuthService.FirebaseAuthServiceError.emailAlreadyInUse

        await sut.createUser()

        XCTAssertEqual(sut.errorMessage, "The email address is already in use by another account.")
        XCTAssertTrue(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
    }

    func testGivenNetworkError_WhenCreatingAccount_ThenNetworkErrorErrorOccurs() async {
        setupUser()
        firebaseAuthService.error = FirebaseAuthService.FirebaseAuthServiceError.networkError

        await sut.createUser()

        XCTAssertEqual(sut.errorMessage, "Please verify your network.")
        XCTAssertTrue(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
    }

    func testGivenDefaultError_WhenCreatingAccount_ThenDefaultErrorOccurs() async {
        setupUser()
        firebaseAuthService.error = FirebaseAuthService.FirebaseAuthServiceError.defaultError

        await sut.createUser()

        XCTAssertEqual(sut.errorMessage, "An error occured.")
        XCTAssertTrue(firebaseAuthService.isCreateUserTriggered)
        XCTAssertTrue(sut.showingAlert)
    }

    func testGivenCorrectFields_WhenCreatingAccount_ThenUserIsCreated() async {
        setupUser()

        await sut.createUser()

        XCTAssertTrue(sut.errorMessage.isReallyEmpty)
        XCTAssertTrue(firebaseAuthService.isCreateUserTriggered)
        XCTAssertFalse(sut.showingAlert)
        XCTAssertEqual(sut.userID, "userID123")
    }

    // MARK: - FIRESTORE AUTH TESTS
    func testGivenNoError_WhenSavingUser_ThenUserIsSaved() {
        setupUser()
        sut.saveUserInDatabase(userID: "userID123")

        XCTAssertTrue(sut.errorMessage.isReallyEmpty)
        XCTAssertTrue(firestoreService.isSaveUserInDatabaseTriggered)
        XCTAssertFalse(sut.showingAlert)
    }

    func testGivenSavingUserInDatabaseWithCannotSaveUserError_WhenSavingUser_ThenCannotSaveUserErrorOccurs() {
        setupUser()
        firestoreService.error = FirestoreService.FirestoreServiceError.cannotSaveUser

        sut.saveUserInDatabase(userID: "userID123")

        XCTAssertEqual(sut.errorMessage, "User could not be saved.")
        XCTAssertTrue(firestoreService.isSaveUserInDatabaseTriggered)
        XCTAssertTrue(sut.showingAlert)
    }

    func testGivenRandomError_WhenSavingUser_ThenDefaultErrorOccurs() {
        setupUser()
        firestoreService.error = CustomError(errorDescription: "")

        sut.saveUserInDatabase(userID: "userID123")

        XCTAssertEqual(sut.errorMessage, "Something went wrong, please try again.")
        XCTAssertTrue(firestoreService.isSaveUserInDatabaseTriggered)
        XCTAssertTrue(sut.showingAlert)
    }
}
