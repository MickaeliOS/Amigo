//
//  LoginView.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Text("Amigo")
                    .font(.largeTitle)
                
                Spacer()
                
                TextField("Username", text: $username)
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
                    SecureField("Password", text: $password)
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
                        //TODO: Rediriger vers le menu Home
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
                    
                    Button("Sign up") {
                        //TODO: Rediriger vers le formulaire de création de compte
                    }
                    .font(.headline)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
