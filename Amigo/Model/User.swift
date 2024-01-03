//
//  User.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import Foundation

struct User: Codable {
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }

    let lastname: String
    let firstname: String
    let email: String
    let birthdate: Date
    let gender: String
    var profilePicture: String?
}
