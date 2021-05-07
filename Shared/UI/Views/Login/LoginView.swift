//
//  LoginView.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var appDataContainer: AppDataContainer
    
    var body: some View {
        VStack {
            HeaderView()
                .padding(.top, 134)
            
            VStack(spacing: 16) {
                UsernameField()
                PasswordField()
                
                Button {
                    withAnimation {
                        appDataContainer.performLogin()
                    }
                } label: {
                    Text("Log in")
                        .foregroundColor(.white)
                }
                .disabled(!appDataContainer.isValid)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 40)
                .background(appDataContainer.isValid ? Color.mainBlue : Color.mainBlue.opacity(0.4))
                .cornerRadius(10)
                .padding(.top, 8)
            }
            .padding(.top, 40)
            .padding(.horizontal, 32)
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                Image("background")
                    .resizable()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppDataContainer())
    }
}
