//
//  Tab1View.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct AccountTabView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        VStack(spacing: 20) {
            if let user = auth.username {
                Text("Logged in as \(user)")
                    .font(.headline)
            }
            
            Button("Log Out") {
                auth.logOut()
            }
            .buttonStyle(.bordered)
            
            // You can add more account-related buttons here:
            Button("Manage Profile") { /* TODO */ }
            Button("Security Settings") { /* TODO */ }
        }
        .padding()
    }
}

