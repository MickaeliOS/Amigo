//
//  PasswordView.swift
//  Amigo
//
//  Created by Mickaël Horn on 03/10/2023.
//

import SwiftUI

struct PasswordView: View {
    let fieldName: String

    @State private var isSecure = true
    @Binding var password: String

    var body: some View {
        if isSecure {
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)

                SecureField(fieldName, text: $password)
                    .textInputAutocapitalization(.never)
                    .overlay(Button {
                        isSecure.toggle()
                        print("SecureField")
                    } label: {
                        Image(systemName: "eye.slash")
                            .foregroundColor(.gray)
                    }, alignment: .trailing)
            }
        } else {
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)

                TextField(fieldName, text: $password)
                    .textInputAutocapitalization(.never)
                    .overlay(Button {
                        isSecure.toggle()
                        print("TextField")
                    } label: {
                        Image(systemName: "eye")
                            .foregroundColor(.gray)
                    }, alignment: .trailing)
            }
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(fieldName: "PreviewField", password: .constant("12345"))
    }
}
