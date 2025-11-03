//
//  loginWithEmailView.swift
//  WalletBuddies
//
//  Created by Gia Subedi on 19/10/2025.
//

import SwiftUI



struct LoginWithEmailView: View{
    
    @State private var userEmail : String
    @State private var userPassword = ""
    @State private var loggedIn : Bool = false
    
    @EnvironmentObject  var authManager: AuthManager
    init(email:String){
        _userEmail = State(initialValue: email)
    }
    
    
  var duringIncompleteForm : Bool { userEmail.isEmpty || userPassword.isEmpty}
    
    var body : some View{
        VStack(alignment:.center, spacing:20){

            
            
            TextField("Email Address", text : $userEmail)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text : $userPassword)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
            
            
            Button{
                print("button was clicked")
                submitLoginForm()
            } label:{
                HStack{
                    Text("Log In")
                    Image(systemName:"arrow.right")
                }.frame(maxWidth: .infinity)
                
            }.buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .border(Color.white)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(Color.black)
                .padding(.vertical,10)
                .padding(.horizontal,20)
                .disabled(duringIncompleteForm)
                .tint(.black)
                .opacity(duringIncompleteForm ? 0.7 : 1.0)

                Spacer()

                NavigationLink("Sign Up to create an account."){
                SignupView()
            }.foregroundStyle(.white)
            
        }
    }
    
    private func submitLoginForm(){
        guard let loginURL = URL(string:"\(BaseURL)/api/users/login") else {return}
        let payload : [String: Any] = [
            "emailAddress" : userEmail,
            "password" : userPassword,
        ]
        
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
                        authManager.handleLoginResponse(user: user)
                        loggedIn = true
                    }
                } else {
                    print("❌ \(decoded.message)")
                }

            } catch {
                print("❌ Decode error: \(error)")
                print(String(data: data, encoding: .utf8) ?? "")
            }
        }.resume()
        
        func ClearFields(){
            userEmail = ""
            userPassword = ""
        }
}

func validatePassword(passWord : String) -> Bool {
    let passwordFormat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[\\d\\W])(?=\\S{8,})\\S+$"
    return NSPredicate(format: "SELF MATCHES %@", passwordFormat).evaluate(with: passWord)
}
    
func loginSuccess () {
    //clear form
    submitLoginForm()
    ClearFields()
        }
func ClearFields(){
    userEmail = ""
    userPassword = ""
}
        
}

#Preview{
    NavigationStack{
        LoginWithEmailView(email:"example@email.com")
    }.environmentObject(AuthManager())
}
