//
//  ListHeaderView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 07.05.2021.
//

import SwiftUI

struct ListHeaderView: View {
    var body: some View {
        HStack {
            Text("SERVER")
                .foregroundColor(.headerTitle)
            Spacer()
            Text("DISTANCE")
                .foregroundColor(.headerTitle)
        }
        .padding(.horizontal)
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView()
    }
}
