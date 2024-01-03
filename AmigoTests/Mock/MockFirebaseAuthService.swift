//
//  MockFirebaseAuthService.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 19/12/2023.
//

import Foundation
@testable import Amigo

final class MockFirebaseAuthService: FirebaseAuthServiceProtocol {
    var isCreateUserTriggered = false
    var isSignInTriggered = false
    var error: Error?

    func createUser(email: String, password: String) async throws -> FirebaseAuthServiceProtocol.UserID {
        isCreateUserTriggered = true

        if let error = error {
            throw error
        }

        return "userID123"
    }

    func signIn(email: String, password: String) async throws {
        isSignInTriggered = true

        if let error = error {
            throw error
        }
    }
}
