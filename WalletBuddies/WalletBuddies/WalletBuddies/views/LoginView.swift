//
//  LoginView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var showCreateAccount = false
    var onLogin: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                if showCreateAccount {
                    CreateAccountView(
                        onFinish: { onLogin() },
                        pageSelect: $showCreateAccount   // 👈 pass binding
                    )
                    .environmentObject(auth)
                } else {
                    LoginFormView(onLogin: {
                        onLogin()
                    }, pageSelect: $showCreateAccount   // 👈 pass binding
                    )
                    .environmentObject(auth)
                }
                
            }
        }
    }
}
