//
//  CreateAccountView.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @StateObject var viewModel = CreateAccountViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            personalInfos
            accountInfos
            signUpButton
        }
        .navigationTitle("Create Account")
        .padding(.horizontal)
        .alert("Account Creation Error", isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    @ViewBuilder private var personalInfos: some View {
        Text("Personal infos")
            .font(.headline)

        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.gray)

            TextField("Lastname", text: $viewModel.lastname)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)
        )

        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.gray)

            TextField("Firstname", text: $viewModel.firstname)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

        Picker("Gender", selection: $viewModel.gender) {
            ForEach(User.Gender.allCases, id: \.self) { gender in
                Text(gender.rawValue)
            }
        }
        .pickerStyle(.segmented)

        DatePicker("Birthdate", selection: $viewModel.birthdate, displayedComponents: .date)
            .datePickerStyle(.compact)
            .padding()
    }

    @ViewBuilder private var accountInfos: some View {
        Text("Account infos")
            .font(.headline)

        HStack {
            Image(systemName: "envelope.fill")
                .foregroundColor(.gray)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

        PasswordView(fieldName: "Password", password: $viewModel.password)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))

        PasswordView(fieldName: "Confirm Password", password: $viewModel.confirmPassword)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }

    private var signUpButton: some View {
        Button("SignUp") {
            Task {
                await viewModel.createUser()

                if viewModel.userID.isReallyEmpty == false {
                    viewModel.saveUserInDatabase(userID: viewModel.userID)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 10)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccountView()
        }
    }
}
