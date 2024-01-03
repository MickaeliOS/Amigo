//
//  MockFirestoreService.swift
//  AmigoTests
//
//  Created by Mickaël Horn on 19/12/2023.
//

import Foundation
@testable import Amigo

final class MockFirestoreService: FirestoreServiceProtocol {
    var isSaveUserInDatabaseTriggered = false
    var error: Error?

    func saveUserInDatabase(userID: String, user: Amigo.User) throws {
        isSaveUserInDatabaseTriggered = true

        if let error = error {
            throw error
        }
    }

    func fetchUser(userID: String) async throws -> Amigo.User {
        // To delete, just to not generate a warning
        return User(lastname: "",
                    firstname: "",
                    email: "",
                    birthdate: Date.now,
                    gender: User.Gender.male.rawValue, profilePicture: "")
    }
}
