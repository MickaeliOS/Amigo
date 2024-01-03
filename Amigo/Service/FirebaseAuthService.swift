//
//  FirebaseAuthService.swift
//  Amigo
//
//  Created by Mickaël Horn on 05/10/2023.
//

import Foundation
import FirebaseAuth

protocol FirebaseAuthServiceProtocol {
    typealias UserID = String

    func createUser(email: String, password: String) async throws -> UserID
    func signIn(email: String, password: String) async throws
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    func createUser(email: String, password: String) async throws -> String {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return authDataResult.user.uid
        } catch {
            throw handleFirebaseError(error)
        }
    }

    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw handleFirebaseError(error)
        }
    }

    private func handleFirebaseError(_ error: Error) -> FirebaseAuthServiceError {
        let nsError = error as NSError

        switch nsError {
        case AuthErrorCode.emailAlreadyInUse:
            return .emailAlreadyInUse

        case AuthErrorCode.internalError:
            if nsError.userInfo["NSUnderlyingError"].debugDescription.contains("INVALID_LOGIN_CREDENTIALS") {
                return .invalidCredentials
            } else if nsError.userInfo.debugDescription.contains("ERROR_NETWORK_REQUEST_FAILED") {
                return .networkError
            } else {
                return .defaultError
            }

        default:
            return .defaultError
        }
    }
}

extension FirebaseAuthService {
    enum FirebaseAuthServiceError: Error {
        case emailAlreadyInUse
        case invalidCredentials
        case networkError
        case defaultError

        var errorDescription: String {
            switch self {
            case .emailAlreadyInUse:
                return "The email address is already in use by another account."
            case .invalidCredentials:
                return "Incorrect email or password."
            case .networkError:
                return "Please verify your network."
            case .defaultError:
                return "An error occured."
            }
        }
    }
}
