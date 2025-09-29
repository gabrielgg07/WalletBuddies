//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var auth = AuthManager()   // single source of truth
    @State private var isLoggedIn = false
    
    var body: some View {
        if !auth.isLoggedIn {
            LoginView(onLogin: { isLoggedIn = true })
                .environmentObject(auth)
        } else if !auth.isPlaidLinked  {
            //use dispatcher since plaid runs in background thread
            PlaidConnectView {
                DispatchQueue.main.async {
                    auth.isPlaidLinked = true
                }
            }

        } else {
            HomeView()
                .environmentObject(auth)
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(AuthManager())   // supply a dummy instance
        
}
