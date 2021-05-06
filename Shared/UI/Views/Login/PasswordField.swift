//
//  PasswordField.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct PasswordField: View {
    
    // MARK: - Properties
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    // MARK: - Body
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 40)
            .foregroundColor(.fieldBackground).opacity(0.12)
            .overlay(
                HStack(spacing: 9) {
                    Image("lockicon")
                        .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                        .padding(.leading, 8)
                    
                    SecureField("Password", text: $appDataContainer.password)
                        .font(.system(size: 17, weight: .regular))
                }
            )
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField()
    }
}
