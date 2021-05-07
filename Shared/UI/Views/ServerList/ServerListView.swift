//
//  ServerListView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct ServerListView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    @State private var showFilterOptions = false
    
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
                showFilterOptions.toggle()
            }, label: {
                HStack {
                    Image("sorticon")
                    Text("Filter")
                }
            }), trailing: Button(action: {
                appDataContainer.performLogOut()
            }, label: {
                HStack {
                    Image("sorticon")
                    Text("Logout")
                }
            }))
            .actionSheet(isPresented: $showFilterOptions, content: {
                ActionSheet(title: Text("Select option"), buttons: [
                    .default(Text("By distance"), action: {
                        appDataContainer.sortList(by: .distance)
                    }),
                    .default(Text("Alphabetical"), action: {
                        appDataContainer.sortList(by: .alphabetical)
                    })
                ])
            })
        }
    }
}

struct ServerListView_Previews: PreviewProvider {
    static var previews: some View {
        ServerListView()
            .environmentObject(AppDataContainer())
    }
}
