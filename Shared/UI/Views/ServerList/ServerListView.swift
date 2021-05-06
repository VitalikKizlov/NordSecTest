//
//  ServerListView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct ServerListView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    var body: some View {
        List(appDataContainer.serverList) { server in
            ServerRowView(server: server)
        }
    }
}

struct ServerListView_Previews: PreviewProvider {
    static var previews: some View {
        ServerListView()
    }
}
