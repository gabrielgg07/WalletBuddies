//
//  loginView.swift
//  WalletBuddies
//
//  Created by Gia Subedi on 19/10/2025.
//

import SwiftUI


struct LoginView: View{
    @State private var userEmail = ""
    @State private var userPassword = ""
    @EnvironmentObject var auth: AuthManager
    
    
    var duringIncompleteForm : Bool {userEmail.isEmpty}
    
    @State private var formComplete : Bool = false
    
    var body : some View{
        VStack(alignment:.center, spacing:20){
            
            Spacer()
            
            Text("Welcome to WalletBuddies").font(.title2)
                .padding(.vertical,30)
            LoginWithEmailView(email : userEmail)

            if true {
                Button {
                    if let rootVC = UIApplication.shared
                        .connectedScenes
                        .compactMap({ $0 as? UIWindowScene })
                        .first?
                        .windows
                        .first(where: { $0.isKeyWindow })?
                        .rootViewController {
                        
                        auth.signInWithGoogle(presenting: rootVC)
                    }
                } label: {
                    HStack {
                        Image(systemName: "globe") // Replace with Google logo if you want
                        Text("Sign in with Google")
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical,3)
                    
                }
                //.buttonStyle(.glassProminent)
                .tint(.black)
                .padding(.horizontal)
            } else {
                // Fallback on earlier versions
            }
            
            Spacer()
            
            NavigationLink("Sign Up to create an account."){
                SignupView()
            }.foregroundStyle(.white)
            
        }.frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.center)
            .background(Color.brown.opacity(0.8))
               
    }
}

func loginWithEmail(){
    print("Move to next page")
}

