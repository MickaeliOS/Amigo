//
//  HomeTabView.swift
//  Amigo
//
//  Created by Mickaël Horn on 31/10/2023.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var viewModel = HomeTabViewModel()

    var body: some View {
        TabView {
            CreateTripView()
                .tabItem { Label("Create Trip", systemImage: "airplane.departure") }
                .environmentObject(viewModel)
        }
        .onAppear {
            viewModel.fetchUser(userID: sessionManager.userID ?? "")
        }
        .alert("Could not retrieve User", isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
