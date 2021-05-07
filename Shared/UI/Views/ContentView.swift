//
//  ContentView.swift
//  Shared
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    @State private var showLoginErrorAlert = false
    
    var body: some View {
        switch appDataContainer.state {
        case .loggedOut:
            LoginView()
                .onReceive(appDataContainer.showErrorPublisher) { value in
                    if value {
                        showLoginErrorAlert.toggle()
                    }
                }
                .alert(isPresented: $showLoginErrorAlert) {
                    Alert(title: Text("Verification Failed"),
                          message: Text("Your username or password is incorrect."),
                          dismissButton: .default(Text("OK")))
                }
        case .loadingList:
            LoadingListView()
        case .list:
            ServerListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
