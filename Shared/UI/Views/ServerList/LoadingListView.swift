//
//  LoadingListView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct LoadingListView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(.white)
            Image("background")
                .resizable()
            }
            VStack(spacing: 8) {
                ProgressView()
                Text("Loading list")
                    .foregroundColor(.lightGrey).opacity(0.6)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            appDataContainer.getServerList()
        }
    }
}

struct LoadingListView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingListView()
            .environmentObject(AppDataContainer())
    }
}
