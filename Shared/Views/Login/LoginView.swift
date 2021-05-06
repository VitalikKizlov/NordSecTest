//
//  LoginView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            HeaderView()
            
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 40)
                    .foregroundColor(.fieldBackground).opacity(0.12)
                    .overlay(
                        HStack(spacing: 9) {
                            Image("usernameicon")
                                .resizable()
                                .frame(width: 16, height: 16, alignment: .center)
                                .padding(.leading, 8)
                            
                            TextField("Username ", text: $username)
                                .font(.system(size: 17, weight: .regular))
                        }
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 40)
                    .foregroundColor(.fieldBackground).opacity(0.12)
                    .overlay(
                        HStack(spacing: 9) {
                            Image("lockicon")
                                .resizable()
                                .frame(width: 16, height: 16, alignment: .center)
                                .padding(.leading, 8)
                            
                            SecureField("Password", text: $password)
                                .font(.system(size: 17, weight: .regular))
                        }
                    )
            }
            .padding(.top, 40)
            .padding(.horizontal, 32)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
