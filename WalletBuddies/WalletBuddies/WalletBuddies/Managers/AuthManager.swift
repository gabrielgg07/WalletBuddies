//
//  AuthManager.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//

import SwiftUI
import Combine
import GoogleSignIn


struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let user: UserData?
}

struct UserData: Codable {
    let id: Int
    let first_name: String
    let last_name: String?
    let email: String
    let created_at: String
}


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
    

    @Published var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "" {
        didSet {
            UserDefaults.standard.set(email, forKey: "userEmail")
        }
    }

    @Published var userId: Int = UserDefaults.standard.integer(forKey: "userId") {
        didSet {
            UserDefaults.standard.set(userId, forKey: "userId")
        }
    }
    
    init() {
        // Restore Google session on launch
        restorePreviousSignIn()
    }
    




    func handleSignupSuccess(name: String, email: String) {
        self.name = name
        self.email = email
        self.isLoggedIn = true

        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")

        print("✅ User signed up & logged in: \(email)")
    }

    func handleLoginResponse(user: UserData) {
        let fullName = [user.first_name, user.last_name].compactMap { $0 }.joined(separator: " ")
        handleSignupSuccess(name: fullName, email: user.email)
    }
    


    func signOut() {
        self.isLoggedIn = false
        self.name = ""
        self.email = ""
        self.isPlaidLinked = false

        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")

        print("👋 Logged out successfully")
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
    
    func deleteAccount() {

        guard let url = URL(string: "\(BaseURL)/api/users/delete/\(self.userId)") else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"


        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error deleting account:", error.localizedDescription)
                //DispatchQueue.main.async { completion(false) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                //DispatchQueue.main.async { completion(false) }
                return
            }

            if httpResponse.statusCode == 200 {
                print("✅ Account successfully deleted")
                // 🔹 Clear local user data
                DispatchQueue.main.async {
                    self.signOut()
                    //completion(true)
                }
            } else {
                if let data = data,
                   let errorMsg = String(data: data, encoding: .utf8) {
                    print("⚠️ Server error: \(errorMsg)")
                }
                //DispatchQueue.main.async { completion(false) }
            }
        }.resume()
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
