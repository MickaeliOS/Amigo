//
//  CreateTripView.swift
//  Amigo
//
//  Created by Mickaël Horn on 29/09/2023.
//

import SwiftUI
import FirebaseAuth // DELETE

struct CreateTripView: View {
    @EnvironmentObject var homeTabViewModel: HomeTabViewModel

    var body: some View {
        VStack {
            Button { // DELETE
                try? Auth.auth().signOut()
            } label: {
                Text("Signout")
            }

            Text("Hello \(homeTabViewModel.user?.firstname ?? "No user")")
        }
        .onAppear(perform: {
            print("MKA - onAppear de create trip")
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTripView()
    }
}
