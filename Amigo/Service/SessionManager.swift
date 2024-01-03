//
//  SessionManager.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import Foundation
import FirebaseAuth

final class SessionManager: ObservableObject {
    var authStateHandler: AuthStateDidChangeListenerHandle?
    var userID: String?

    @Published var state: State = .loading

    init() {
        registerAuthStateHandler()
    }
}

extension SessionManager {
    enum State {
        case loading
        case loggedOut
        case loggedIn
    }
}

extension SessionManager {
    private func registerAuthStateHandler() {
        authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
            guard let user = user else {
                self.state = .loggedOut
                return
            }

            self.state = .loggedIn
            self.userID = user.uid
        }
    }
}
