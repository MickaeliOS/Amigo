//
//  Extension.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/10/2023.
//

import Foundation

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
