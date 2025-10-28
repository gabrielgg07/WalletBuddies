//
//  LoginView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI


struct DeprecatedLoginView: View {

    //passed down authmanager
    @EnvironmentObject var auth: AuthManager


    var body: some View {
        VStack(spacing: 20) {
            //Header text will add more styling later.
            Text("Welcome to Wallet Buddies!")
                .font(.headline)
            //Create a button that logs you in with google
            Button {
                if let rootVC = UIApplication.shared
                    .connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?
                    .windows
                    .first(where: { $0.isKeyWindow })?
                    .rootViewController {
                    
                    //Call the authenticators function to sign in with google
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
    }
}


