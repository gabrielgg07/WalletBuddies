        //
        //  loginAccountView.swift
        //  WalletBuddies
        //
        //  Created by Gabriel Gonzalez on 9/23/25.
        //

        import SwiftUI

    struct LoginFormView: View {
        var onLogin: () -> Void
        @State private var username = ""
        @State private var password = ""
        @State private var step = 1
        @Binding var pageSelect: Bool
        
        @EnvironmentObject var auth: AuthManager

        var body: some View {
                ZStack {
                    // Background image
                    Image("LoginBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()

                    // Foreground content
                    VStack {
                        if step == 1 {
                            LoginStep1(onNext: { step = 2 })
                        } else {
                            LoginStep2(onFinish: onLogin,
                                       username: $username,
                                       password: $password)
                            .environmentObject(auth)
                        }

                        if step == 1 {
                            Button("Don't have an account? Create one") {
                                withAnimation {
                                    pageSelect = true
                                }
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                    }
                }
        }
    }





        struct LoginStep1: View {
            var onNext: () -> Void
            
            var body: some View {
                Text("Login Step 1")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Button("Continue") {
                    onNext()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .foregroundColor(.white)
            }
        }

        struct LoginStep2: View {
            var onFinish: () -> Void
            @Binding var username: String
            @Binding var password: String
            
            @EnvironmentObject var auth: AuthManager
            var body: some View {
                Text("Login Step 2")
                TextField("Enter username", text: $username)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                TextField("Enter password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                Button("Login") {
                    auth.logIn(username: username, password: password)
                    onFinish()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            

        }
