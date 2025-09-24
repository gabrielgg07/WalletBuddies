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
        if auth.isLoggedIn {
            HomeView()
                .environmentObject(auth)
        } else {
            LoginView(onLogin: { isLoggedIn = true })
                .environmentObject(auth)
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(AuthManager())   // supply a dummy instance
        
}
