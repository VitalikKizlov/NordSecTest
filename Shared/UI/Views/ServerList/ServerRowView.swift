//
//  ServerRowView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct ServerRowView: View {
    
    let server: Server
    
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text("\(server.distance)")
        }
        .padding(.horizontal, 16)
    }
}
