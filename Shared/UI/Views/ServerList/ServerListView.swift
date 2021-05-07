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
        NavigationView {
            List {
                Section(header: ListHeaderView()) {
                    ForEach(appDataContainer.serverList) { server in
                        ServerRowView(server: server)
                    }
                }
            }
            .navigationBarTitle("Testio.", displayMode: .inline)
            .listStyle(GroupedListStyle())
            .navigationBarItems(leading: Button(action: {
                print("filter by")
            }, label: {
                HStack {
                    Image("sorticon")
                    Text("Filter")
                }
            }), trailing: Button(action: {
                print("log out")
            }, label: {
                HStack {
                    Image("sorticon")
                    Text("Logout")
                }
            }))
        }
    }
}

struct ServerListView_Previews: PreviewProvider {
    static var previews: some View {
        ServerListView()
            .environmentObject(AppDataContainer())
    }
}
