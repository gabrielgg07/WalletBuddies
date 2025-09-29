//
//  AuthManager.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//

import SwiftUI
import Combine
import GoogleSignIn

class AuthManager: ObservableObject {
    @Published var isPlaidLinked: Bool = false {
        didSet {
            UserDefaults.standard.set(isPlaidLinked, forKey: "isPlaidLinked")
        }
    }
    @Published var isLoggedIn: Bool = false {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var name: String = "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "userName")
        }
    }
    
    
    init() {
        // Restore Google session on launch
        restorePreviousSignIn()
    }
    
    
    func signOut() {
        // Signs out locally (Google token is kept, so user could sign in again quickly)
        GIDSignIn.sharedInstance.signOut()
        
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.name = ""
        }
    }
    
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                DispatchQueue.main.async {
                    self.name = user.profile?.name ?? "Anonymous"
                    self.isLoggedIn = true
                    self.isPlaidLinked = true
                    print("✅ Restored session for: \(user.profile?.email ?? "unknown email")")
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.name = ""
                    self.isPlaidLinked = false
                    print("ℹ️ No previous Google session found")
                }
            }
        }
    }
    
    func disconnect() {
        // Fully revokes access (user must grant permission again next login)
        GIDSignIn.sharedInstance.disconnect { error in
            if let error = error {
                print("❌ Disconnect failed: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.name = ""
                }
                print("✅ Disconnected from Google account")
            }
        }
    }
    
    func signInWithGoogle(presenting viewController: UIViewController) {
        // Your Google OAuth Client ID (from Google Cloud console)
        let clientID = "243679696449-1u67ftc5thcuepbnqj28revb6mph0b2t.apps.googleusercontent.com"
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {
                print("❌ No user returned from Google Sign-In")
                return
            }
            self.name = user.profile?.name ?? "Anonymous"
            print("✅ Signed in as: \(user.profile?.email ?? "unknown email")")
            
            
            // ----------------------------------------------------------
            // 🔑 1. Get Google ID token or email for backend auth
            // let idToken = user.idToken?.tokenString
            // let email = user.profile?.email
            
            // 🔑 2. Send id token to your backend:
            // - If user does NOT exist, backend creates new user record returns info
            // - If user DOES exist, backend just returns their info
            
            // 🔑 3. Backend responds with user data, including
            // whether they have Plaid linked (true/false).
            
            // Example (pseudo-code):
            // MyAPI.loginWithGoogle(idToken: idToken) { plaidLinked in
            //     DispatchQueue.main.async {
            //         self.isPlaidLinked = plaidLinked
            //         self.isLoggedIn = true
            //     }
            // }
            // ----------------------------------------------------------
            
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        }
        
        
    }
}
