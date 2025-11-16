//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//  Is the overall view for the app and manages between
//  three root pages, the page you see when logged out, the home page, and the plaid connect page.
import SwiftUI


struct ContentView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {

        NavigationStack{
            if !auth.isLoggedIn && !auth.tryLogin {
                LoginView()
            }
            else if !auth.isLoggedIn && auth.tryLogin {
                LoginWithEmailView()
            }
            else if auth.role == "admin"{
                AdminHomeView()
            }
            else if !auth.isPlaidLinked  {
                //use dispatcher since plaid runs in background thread
                PlaidConnectView {
                    DispatchQueue.main.async {
                        auth.isPlaidLinked = true
                    }
                }
                
            }
            else {
                    HomeView()
                }
            }
        }
    }




#Preview {
    ContentView()
    // supply a dummy instance
        .environmentObject(AuthManager())
}

