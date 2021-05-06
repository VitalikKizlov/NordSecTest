//
//  ContentView.swift
//  Shared
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    var body: some View {
        switch appDataContainer.state {
        case .loggedOut:
            LoginView()
        case .loadingList:
            LoadingListView()
        case .list:
            ServerListView()
        case .error:
            Text("Error")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
