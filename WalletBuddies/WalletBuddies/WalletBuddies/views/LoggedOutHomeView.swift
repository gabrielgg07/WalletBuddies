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
            VStack(spacing: 20) {
                Text("Welcome to Wallet Buddies!")
                    .font(.headline)
                
                // Standard login form
                /**
                NavigationLink("Login") {
                    //LoginFormView(onLogin: { onLogin() })
                    //   .environmentObject(auth)
                }
                .buttonStyle(.borderedProminent)
                */
                
                
                // Create account flow
                /**
                NavigationLink("Create Account") {
                    //CreateAccountView(onFinish: { onLogin() })
                      //  .environmentObject(auth)
                }
                .buttonStyle(.borderedProminent)
                 */
                // ---- Google Sign-In ----
                Button {
                    if let rootVC = UIApplication.shared
                        .connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?
                        .windows
                        .first(where: { $0.isKeyWindow })?
                        .rootViewController {
                        
                        auth.signInWithGoogle(presenting: rootVC)
                    }
                } label: {
                    HStack {
                        Image(systemName: "globe") // Replace with Google logo if you want
                        Text("Sign in with Google")
                    }
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Welcome")
        }
    }
}
