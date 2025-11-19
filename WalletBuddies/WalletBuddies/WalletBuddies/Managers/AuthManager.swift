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
    let linked: Bool
}

struct UserData: Codable {
    let id: Int
    let name: String
    let email: String
    let created_at: String
    let role: String
}


class AuthManager: ObservableObject {
    @Published var isPlaidLinked: Bool = false {
        didSet {
            UserDefaults.standard.set(isPlaidLinked, forKey: "isPlaidLinked")
        }
    }
    @Published var tryLogin: Bool = false {
        didSet {
            UserDefaults.standard.set(tryLogin, forKey: "tryLogin")
        }
    }
    @Published var isLoggedIn: Bool = false {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var trySignup: Bool = false {
        didSet {
            UserDefaults.standard.set(trySignup, forKey: "trySignup")
        }
    }
    @Published var loginSource: String = "Email" {
        didSet {
            UserDefaults.standard.set(loginSource, forKey: "loginSource")
        }
    }
    @Published var userAlreadyExists: Bool = false{
        didSet {
            UserDefaults.standard.set(userAlreadyExists, forKey: "userAlreadyExists")
        }
    }
    @Published var userDoesntExist: Bool = false{
        didSet {
            UserDefaults.standard.set(userDoesntExist, forKey: "userDoesntExist")
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
    @Published var gidToken: String = UserDefaults.standard.string(forKey: "gidToken") ?? "" {
        didSet {
            UserDefaults.standard.set(gidToken, forKey: "gidToken")
        }
    }
    @Published var role: String = UserDefaults.standard.string(forKey: "accountRole") ?? "" {
        didSet {
            UserDefaults.standard.set(role, forKey: "accountRole")
        }
    }
    @Published var tempEmail: String = UserDefaults.standard.string(forKey: "tempEmail") ?? "" {
        didSet {
            UserDefaults.standard.set(tempEmail, forKey: "tempEmail")
        }
    }
    
    init() {
        // Restore Google session on launch
        restorePreviousSignIn()
    }
    




    func handleSignupSuccess(name: String, email: String) {
        self.name = name
        self.email = email
        self.role = role
        self.isLoggedIn = true
        self.trySignup = false

        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(role, forKey: "accountRole")

        

        print("✅ User signed up & logged in: \(email)")
    }
    

    func handleLoginResponse(user: UserData) {
        self.name = user.name
        self.role = user.role
        handleSignupSuccess(name: user.name, email: user.email)
    }
    


    func signOut() {
        self.isLoggedIn = false
        self.tryLogin = false
        self.loginSource = "Email"
        self.tempEmail = ""
        self.name = ""
        self.email = ""
        self.role = ""
        self.gidToken = ""
        self.isPlaidLinked = false
        self.userAlreadyExists = false
        self.userDoesntExist = false

        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "accountRole")
        UserDefaults.standard.removeObject(forKey: "tryLogin")

        print("👋 Logged out successfully")
    }
    
    func clearValues(){
        self.isLoggedIn = false
        self.tryLogin = false
        self.loginSource = "Email"
        self.tempEmail = ""
        self.name = ""
        self.email = ""
        self.role = ""
        self.gidToken = ""
        self.isPlaidLinked = false
        self.trySignup = false
        self.userAlreadyExists = false
        self.userDoesntExist = false

        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "accountRole")
        UserDefaults.standard.removeObject(forKey: "tryLogin")
    }
    
    
    func restorePreviousSignIn() {
        self.clearValues()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user {
                self.name = user.profile?.name ?? "Anonymous"
                self.email = user.profile?.email ?? ""
//                self.gidToken = user.idToken
                self.loginSource = "Google"
                self.submitLoginForm()
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
            
            
//                DispatchQueue.main.async {
//                    self.name = user.profile?.name ?? "Anonymous"
//                    self.loginSource = "Google"
//                    self.email = user.profile?.email
//                    ?? UserDefaults.standard.string(forKey: "userEmail")
//                    ?? ""
//                    if self.role == ""{
//                        self.role = "user"
//                    }
//                    self.isLoggedIn = true
//                    self.isPlaidLinked = true
//                    print("✅ Restored session for: \(user.profile?.email ?? "unknown email")")
//                }
//            } else {
//                DispatchQueue.main.async {
//                    self.isLoggedIn = false
//                    self.name = ""
//                    self.isPlaidLinked = false
//                    print("ℹ️ No previous Google session found")
//                }
//            }
//        }
//    }
    
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
    
    func submitLoginForm(){
        guard let loginURL = URL(string:"\(BaseURL)/api/users/login") else {return}
        let payload : [String:Any] = ["emailAddress" : self.email/*, "GID_Token" : self.gidToken*/, "source" : self.loginSource ]
        var sendRequest = URLRequest(url : loginURL)
        sendRequest.httpMethod = "POST"
        sendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        sendRequest.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: sendRequest){ data, response, error in
            if (error != nil){
                print("Error!")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

                if decoded.success, let user = decoded.user {
                    
                    DispatchQueue.main.async {
                        self.isPlaidLinked = decoded.linked
                        self.handleLoginResponse(user: user)
                    }
                } else {
                    let errorMessage = decoded.message
                    if errorMessage == "User not found"{
                        self.disconnect()
                        self.userDoesntExist = true
                    }
                    print("❌ \(decoded.message)")
                }

            } catch {
                print("❌ Decode error: \(error)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
}

        
    
    
    func submitSignupForm(){
        guard let signupURL = URL(string:"\(BaseURL)/api/users/signup") else {return}
        let payload : [String:Any] = ["userName" : self.name, "emailAddress" : self.email, "GID_Token" : self.gidToken, "source" : self.loginSource ]
        var sendRequest = URLRequest(url : signupURL)
        sendRequest.httpMethod = "POST"
        sendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        sendRequest.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: sendRequest){ data, response, error in
            if (error != nil){
                print("Error!")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

                if decoded.success{
                    DispatchQueue.main.async {
                        self.handleSignupSuccess(name: self.name, email: self.email)
                    }
                } else {
                    let errorMessage = decoded.message
                    print("❌ \(decoded.message)")
                    if errorMessage == "User already exists"{
                        self.disconnect()
                        self.userAlreadyExists = true
                    }
                }

            } catch {
                print("❌ Decode error: \(error)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
}
        

    
    func deleteAccount() {

        guard let url = URL(string: "\(BaseURL)/api/users/deleteAccount") else {
            print("❌ Invalid URL")
            return
            
        }
        let payload : [String: Any] = [
            "userEmail" : self.email
        ]
        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)


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
    
    
    func loginWithGoogle(presenting viewController: UIViewController){
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
            guard let idToken = user.idToken?.tokenString else{
                print("❌ No GID token")
                return
            }
            self.name = user.profile?.name ?? "Anonymous"
            self.email = user.profile?.email ?? ""
            self.gidToken = idToken
            self.loginSource = "Google"
            self.submitLoginForm()
            
        }
    }
    
    func signupWithGoogle(presenting viewController: UIViewController) {
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
            guard let idToken = user.idToken?.tokenString else{
                print("❌ No GID token")
                return
            }
            self.name = user.profile?.name ?? "Anonymous"
            self.email = user.profile?.email ?? ""
            self.gidToken = idToken
            self.loginSource = "Google"
            self.submitSignupForm()
            
            
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
            
//            DispatchQueue.main.async {
//                self.isLoggedIn = true
//                self.handleSignupSuccess(name: self.name, email: self.email)
//
//            }
        }
        
    }
}
