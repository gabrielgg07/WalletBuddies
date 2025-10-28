//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//  Is the overall view for the app and manages between
//  three root pages, the page you see when logged out, the home page, and the plaid connect page.
//

//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var isLoggedIn = false
    @StateObject private var userData = UserDataManager.shared
    var body: some View {
        NavigationStack{
            if !auth.isLoggedIn {
                LoginView()
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
                    .environmentObject(userData)
            }
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(AuthManager())   // supply a dummy instance
        
}

