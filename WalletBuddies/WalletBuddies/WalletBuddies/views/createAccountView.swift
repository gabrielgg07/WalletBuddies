//
//  createAccountView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct CreateAccountView: View {
    var onFinish: () -> Void
    @Binding var pageSelect: Bool
    @State private var step = 1
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var auth: AuthManager
    var body: some View {
        VStack {
            //Potentially wrap in enum switch or something better
            if step == 1 {
                createAccountStep1(onNext: {
                    withAnimation {
                        step = 2
                    }
                })
            } else if step == 2 {
                createAccountStep2(
                    onNext: {
                        withAnimation {
                            step = 3
                        }
                    },
                    username: $username,
                    password: $password
                )
                .environmentObject(auth)
            }   else if step == 3 {
                PlaidConnectView(onFinish: onFinish)
            }
            if step != 3{
                Button("Already Have an account? Log in"){
                    withAnimation {
                        pageSelect = false
                    }
                }
                .padding()
            }
        }
    }
}


struct createAccountStep1: View {
    var onNext: () -> Void
    
    var body: some View {
        Text("Create Account")
            .font(.largeTitle)
        // TODO: Add text fields for registration
        
        Button("Sign Up") {
            onNext()
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

struct createAccountStep2: View {
    var onNext: () -> Void
    @Binding var username: String
    @Binding var password: String
    
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        Text("Enter Username and Password")
        TextField("Enter username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .padding()
        TextField("Enter password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding()
        Button("CreateAccount") {
            print("Username: \(username)")
            print("Password: \(password)")
            
            auth.logIn(username: username, password: password)
            onNext()
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
}

