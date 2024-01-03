//
//  CreateAccountViewModel.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/10/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class CreateAccountViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var lastname = ""
    @Published var firstname = ""
    @Published var birthdate = Date.now
    @Published var gender = User.Gender.other
    @Published var showingAlert = false
    @Published var errorMessage = ""

    var userID = ""
    private let firebaseAuthService: FirebaseAuthServiceProtocol
    private var firestoreService: FirestoreServiceProtocol

    var hasEmptyField: Bool {
        return email.isReallyEmpty
        || password.isReallyEmpty
        || confirmPassword.isReallyEmpty
        || lastname.isReallyEmpty
        || firstname.isReallyEmpty
        || gender.rawValue.isReallyEmpty
    }

    enum FormError: Error {
        case emptyFields
        case passwordsNotEquals

        var errorDescription: String {
            switch self {
            case .emptyFields:
                return "All fields must be filled."
            case .passwordsNotEquals:
                return "Passwords must be equals."
            }
        }
    }

    init(firebaseAuthService: FirebaseAuthServiceProtocol = FirebaseAuthService(),
         firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firebaseAuthService = firebaseAuthService
        self.firestoreService = firestoreService
    }
}

extension CreateAccountViewModel {
    func createUser() async {
        do {
            try formCheck()
            userID = try await firebaseAuthService.createUser(email: email, password: password)
        } catch {
            showingAlert.toggle()
            errorMessage = handleError(error: error)
        }
    }

    func saveUserInDatabase(userID: String) {
        do {
            let user = User(
                lastname: lastname,
                firstname: firstname,
                email: email,
                birthdate: birthdate,
                gender: gender.rawValue
            )

            try firestoreService.saveUserInDatabase(userID: userID, user: user)
        } catch {
            showingAlert.toggle()
            errorMessage = handleError(error: error)
        }
    }

    private func formCheck() throws {
        guard !hasEmptyField else {
            throw FormError.emptyFields
        }

        guard AuthenticationTools.emailControl(email: email) else {
            throw AuthenticationTools.AuthenticationError.emailBadlyFormatted
        }

        guard AuthenticationTools.isValidPassword(password) else {
            throw AuthenticationTools.AuthenticationError.weakPassword
        }

        guard passwordEqualityCheck(password: password, confirmPassword: confirmPassword) else {
            throw FormError.passwordsNotEquals
        }
    }

    private func passwordEqualityCheck(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }

    private func handleError(error: Error) -> String {
        switch error {
        case let formError as FormError:
            return formError.errorDescription
        case let authenticationError as AuthenticationTools.AuthenticationError:
            return authenticationError.errorDescription
        case let authErrorCode as FirebaseAuthService.FirebaseAuthServiceError:
            return authErrorCode.errorDescription
        case let firestoreServiceError as FirestoreService.FirestoreServiceError:
            return firestoreServiceError.errorDescription
        default:
            return "Something went wrong, please try again."
        }
    }
}
