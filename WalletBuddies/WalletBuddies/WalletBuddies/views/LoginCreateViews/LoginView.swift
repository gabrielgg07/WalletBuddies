//
//  loginView.swift
//  WalletBuddies
//
//  Created by Gia Subedi on 19/10/2025.
//

import SwiftUI


struct LoginView2: View{
    @State private var userEmail = ""
    @EnvironmentObject var auth: AuthManager
    
    var duringIncompleteForm : Bool {userEmail.isEmpty}
    
    @State private var formComplete : Bool = false
    
    var body : some View{
        VStack(alignment:.center, spacing:20){
            
            Spacer()
            
            Text("Welcome to WalletBuddies").font(.title2)
                .padding(.vertical,30)
    
            
            TextField("Email Address", text : $userEmail)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
            
            //            TextField("Password", text : $userPassword)
            //                .textFieldStyle(.roundedBorder)
            //                .disableAutocorrection(true)
            //                .frame(maxWidth: .infinity)
            //                .padding(.horizontal, 20)
            
            if #available(iOS 26.0, *) {
                Button{
                    print("button was clicked")
                    if duringIncompleteForm != true{
                        formComplete = true
                    }
                    
                } label:{
                    HStack{
                        Text("Log In")
                        Image(systemName:"arrow.right")
                    }.frame(maxWidth: .infinity)
                    
                }.buttonStyle(.glassProminent)
                    .frame(maxWidth: .infinity)
                //                .border(Color.white)
                    .buttonBorderShape(.roundedRectangle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
//                    .background(Color.black)
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                //                .disabled(duringIncompleteForm)
                    .tint(.black)
                //                .opacity(duringIncompleteForm ? 0.7 : 1.0)
                    .navigationDestination(isPresented: $formComplete){
                        LoginWithEmailView(email : userEmail)
                    }
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 26.0, *) {
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
                .buttonStyle(.glassProminent)
                .tint(.black)
                .padding(.horizontal)
            } else {
                // Fallback on earlier versions
            }
            
            Spacer()
            
            NavigationLink("Sign Up to create an account."){
                signupView()

            }.foregroundStyle(.white)
            
        }.frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.center)
            .background(Color.brown.opacity(0.8))
               
    }
}

func loginWithEmail(){
    print("Move to next page")
}
#Preview {
    NavigationStack{
    LoginView()
}
}
