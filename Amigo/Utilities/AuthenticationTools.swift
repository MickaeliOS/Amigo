//
//  AuthenticationTools.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/01/2024.
//

import Foundation

struct AuthenticationTools {

    enum AuthenticationError: Error {
        case emailBadlyFormatted
        case weakPassword

        var errorDescription: String {
            switch self {
            case .emailBadlyFormatted:
                return "Badly formatted email, please provide a correct one."
            case .weakPassword:
                return """
                Your password is too weak. It must be :
                - At least 7 characters long
                - At least one uppercase letter
                - At least one number
                """
            }
        }
    }
    static func emailControl(email: String) -> Bool {
        // Firebase already warns us about badly formatted email addresses, but this involves a network call.
        // To help with Green Code, I prefer to handle the email format validation myself.

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        // Same logic as the email verification.
        let regex = #"(?=^.{7,}$)(?=^.*[A-Z].*$)(?=^.*\d.*$).*"#

        return password.range(
            of: regex,
            options: .regularExpression
        ) != nil
    }
}
