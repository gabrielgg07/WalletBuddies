//
//  createAccountView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct CreateAccountView: View {
    var onFinish: () -> Void
    @State private var step = 1
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var auth: AuthManager
    var body: some View {
        VStack {
            //Potentially wrap in enum switch or something better


            if step > 1 {
                Button(action: {
                    withAnimation { step -= 1 }
                }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }

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
            }   else if step == 3 {
                PlaidConnectView(onFinish: { auth.isLoggedIn = true
                }
                )

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
            
            onNext()
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    
}

#Preview {
    CreateAccountView(
        onFinish: { print("Finished in preview") },
    )
    .environmentObject(AuthManager()) // dummy auth manager
}

