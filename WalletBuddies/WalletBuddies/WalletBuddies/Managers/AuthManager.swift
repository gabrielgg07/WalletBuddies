//
//  AuthManager.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//

import Foundation

final class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String? = nil
    
    init() {
        // Restore login state when app launches
        if UserDefaults.standard.bool(forKey: "loggedIn") {
            self.isLoggedIn = true
            self.username = UserDefaults.standard.string(forKey: "username")
        }
    }
    
    func logIn(username: String, password: String) {
        // ⚠️ Replace with backend auth later
        self.username = username
        self.isLoggedIn = true
        
        // Save state to UserDefaults (for persistence)
        UserDefaults.standard.set(true, forKey: "loggedIn")
        UserDefaults.standard.set(username, forKey: "username")
        
        print("✅ Logged in as \(username)")
    }
    
    func logOut() {
        self.username = nil
        self.isLoggedIn = false
        
        // Clear from UserDefaults
        UserDefaults.standard.removeObject(forKey: "loggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
        
        print("👋 Logged out")
    }
}
