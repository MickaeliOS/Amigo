//
//  SignInView.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import SwiftUI
import FirebaseAuth // DELETE

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("Amigo")
                    .font(.largeTitle)

                Spacer()

                TextField("Username", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .frame(height: proxy.size.height * 0.06)
                    .padding()
                    .padding(.leading, 30)
                    .background(.thinMaterial)
                    .keyboardType(.emailAddress)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(Image(systemName: "envelope")
                        .foregroundColor(.gray)
                        .padding(.leading, 15),
                    alignment: .leading)

                HStack {
                    SecureField("Password", text: $viewModel.password)
                        .frame(height: proxy.size.height * 0.06)
                        .padding()
                        .padding(.leading, 30)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .padding(.leading, 15),
                        alignment: .leading)
                }

                HStack {
                    Spacer()

                    Button("Login") {
                        Task {
                            await viewModel.signIn()
                        }
                    }
                    .frame(width: proxy.frame(in: .local).midX)
                    .padding([.top, .bottom])
                    .background(.mint)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(.white)
                    .font(.title2)
                }

                Spacer()

                HStack {
                    Text("Don't have an account?")

                    NavigationLink {
                        CreateAccountView()
                    } label: {
                        Text("Signup")
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .alert("Login Error", isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
