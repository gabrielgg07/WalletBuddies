//
//  loginWithEmailView.swift
//  WalletBuddies
//
//  Created by Gia Subedi on 19/10/2025.
//

import SwiftUI



struct LoginWithEmailView: View{
    
    @State private var userEmail : String = ""
    @State private var userPassword = ""
    @State private var errorMessage = ""
    @State private var loggedIn : Bool = false
    @State private var passwordIsIncorrect : Bool = false
    
    @EnvironmentObject  var auth: AuthManager
    
    
  var duringIncompleteForm : Bool { userEmail.isEmpty || userPassword.isEmpty}
    
    var body : some View{
        VStack(alignment:.center, spacing:20){

            Spacer()
            
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
            
            ZStack(alignment: .topLeading){
                if passwordIsIncorrect {
                    Text(errorMessage /*⚠️*/).foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,15)
                        .offset(y: 15)
                }
            }
            
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

            Button{
                auth.trySignup = true
            } label:{
                HStack{
                    Text("Sign Up to create an account.")
                }.frame(maxWidth: .infinity)
            }.foregroundColor(.white)
            
        }.frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.center)
            .background(Color.brown.opacity(0.8))
            .onAppear{
                if userEmail.isEmpty{
                    userEmail = auth.tempEmail
                }
            }
    }
    
    private func submitLoginForm(){
        guard let loginURL = URL(string:"\(BaseURL)/api/users/login") else {return}
        let payload : [String: Any] = [
            "emailAddress" : userEmail,
            "password" : userPassword,
            "source" : auth.loginSource
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
                        auth.handleLoginResponse(user: user)
                        loggedIn = true
                    }
                } else {
                    passwordIsIncorrect = true
                    errorMessage = decoded.message
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

//#Preview{
//    LoginWithEmailView()
//}
