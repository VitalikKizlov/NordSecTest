//
//  UsernameField.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct UsernameField: View {
    
    // MARK: - Properties
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    // MARK: - Body
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 40)
            .foregroundColor(.fieldBackground).opacity(0.12)
            .overlay(
                HStack(spacing: 9) {
                    Image("usernameicon")
                        .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                        .padding(.leading, 8)
                    
                    TextField("Username ", text: $appDataContainer.username)
                        .font(.system(size: 17, weight: .regular))
                        .autocapitalization(.none)
                }
            )
    }
}

struct UsernameField_Previews: PreviewProvider {
    static var previews: some View {
        UsernameField()
    }
}
