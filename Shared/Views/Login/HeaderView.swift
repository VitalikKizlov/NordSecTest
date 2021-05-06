//
//  HeaderView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Image("testio")
                .resizable()
                .frame(width: 170, height: 48, alignment: .center)
            Circle()
                .foregroundColor(.green)
                .frame(width: 12, height: 12, alignment: .center)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
