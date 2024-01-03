//
//  HomeTabViewModel.swift
//  Amigo
//
//  Created by Mickaël Horn on 31/10/2023.
//

import Foundation
import FirebaseAuth

@MainActor
final class HomeTabViewModel: ObservableObject {
    @Published var user: User?
    @Published var showingAlert = false
    @Published var errorMessage = ""

    private var firestoreService: FirestoreServiceProtocol

    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func fetchUser(userID: String) {
        Task {
            do {
                user = try await firestoreService.fetchUser(userID: userID)
            } catch let error as FirestoreService.FirestoreServiceError {
                handleError(with: error.errorDescription)
            }
        }
    }

    private func handleError(with message: String) {
        showingAlert.toggle()
        errorMessage = message
    }
}
