//
//  signupView.swift
//  WalletBuddies
//  Created by Gia Subedi on 11/10/2025.
//

import SwiftUI

struct SignupView: View{
    @State private var fName = ""
    @State private var lName = ""
    @State private var userEmail = ""
    @State private var userPassword = ""
    @State private var checkPassword = ""
    @State private var accountCreated = false
    @State private var displayName = ""
    
    
    @FocusState private var inFocusFeild : Field?
    enum Field{
        case email
        case password
    }
   
    var duringIncompleteForm : Bool {fName.isEmpty || userEmail.isEmpty || userPassword.isEmpty || checkPassword.isEmpty}
    
    var  firstNameNotValidated : Bool {
        !fName.isEmpty && fName.count < 2
    }
    var emailNotValidated : Bool
    {!userEmail.contains("@") && !userEmail.isEmpty}
    
    var passwordNotValidated : Bool{
        !userPassword.isEmpty && !validatePassword(passWord : userPassword)
    }
    
    var passwordsDontMatch : Bool{userPassword != checkPassword && !checkPassword.isEmpty
    }
    
    var allGood : Bool{
        !duringIncompleteForm && !firstNameNotValidated && !emailNotValidated && !passwordNotValidated && !passwordsDontMatch
    }
    
    
    var body : some View{
        
        VStack(alignment:.center, spacing:35, content: {
            
            Text("Create a Profile").fontWeight(.heavy)       .foregroundStyle(Color.white)
            
            ZStack(alignment: .topLeading){
                if firstNameNotValidated {
                    Text("First name should be at least 2 characters long").foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,20)
                        .offset(y: -25)
                }
                
                TextField("First Name", text : $fName)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                
            }
        
            TextField("Last Name", text : $lName)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            
            ZStack(alignment: .topLeading){
                if emailNotValidated {
                    Text("Email needs to have @").foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,20)
                        .offset(y: -25)
                       
                
                }
                    
                    TextField("Email Address", text : $userEmail)
                        .textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .textInputAutocapitalization(.never)
            }
            
            ZStack(alignment: .topLeading){
                if passwordNotValidated{
                    Text("Password format incorrect").foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,20)
                        .offset(y: -25)
                }
                
                SecureField("Enter password", text : $userPassword)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .textContentType(.none)
            }
            
            ZStack(alignment: .topLeading){
                if passwordsDontMatch{
                    Text("Passwords do not match ").foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.horizontal,20)
                        .offset(y: -25)
                }
                
                SecureField("Re-enter Password", text : $checkPassword)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
            }
            
            Button("Create Account",systemImage: "person.badge.plus"){
                print("button was clicked")
                createAccount(validate: allGood)
            }.buttonStyle(.borderedProminent)
                .border(Color.white)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(Color.brown)
                .padding(.vertical,30)
                .padding(.horizontal,10)
                .disabled(!allGood)
                .tint(.brown)
                .opacity(duringIncompleteForm ? 0.7 : 1.2)
            
            
        }).frame(maxWidth :.infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.brown.opacity(0.8))
            .navigationDestination(isPresented: $accountCreated){
                AccountCreationSuccessView(firstName: displayName)
            }
    }

    func validatePassword(passWord : String) -> Bool {
        let passwordFormat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[\\d\\W])(?=\\S{8,})\\S+$"
        return NSPredicate(format: "SELF MATCHES %@", passwordFormat).evaluate(with: passWord)
    }
    
    private func submitSignupForm(){
        guard let signupURL = URL(string:"http://127.0.0.1:5001/api/users/signup") else {return}
        let payload : [String: Any] = [
            "firstName" : fName,
            "lastName" : lName,
            "emailAddress" : userEmail,
            "password" : userPassword,
        ]
        
        var sendRequest = URLRequest(url : signupURL)
        sendRequest.httpMethod = "POST"
        sendRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        sendRequest.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: sendRequest){ data, _, _ in
            if let data = data{
                print(String(data:data,encoding: .utf8) ?? "")
            }
            
        }.resume()
        
        
    }
    
    func createAccount (validate : Bool) {
        if validate{
//clear form
            submitSignupForm()
            displayName = fName
            accountCreated = true
            ClearFields()
            
            
        }
            else{
                print("Account not created")
            }
        }
    
    func ClearFields(){
        fName = ""
        lName = ""
        userEmail = ""
        userPassword = ""
        checkPassword = ""
    }

    }
    


#Preview {
    NavigationStack{
        SignupView()
    }
}
