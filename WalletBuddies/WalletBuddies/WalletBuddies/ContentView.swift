//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//  Is the overall view for the app and manages between
//  three root pages, the page you see when logged out, the home page, and the plaid connect page.
//

import SwiftUI


struct ContentView: View {
    //The authentication manager that persists important login info between app closing.
    @StateObject private var auth = AuthManager()
    @State private var isLoggedIn = false
    
    var body: some View {
        //if not login in prompt the user with a login page
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
            // the user is connected to plaid and logged in load up the home page
            HomeView()
                .environmentObject(auth)
        }
    }
}



#Preview {
    ContentView()
        .environmentObject(AuthManager())   // supply a dummy instance
        
}
