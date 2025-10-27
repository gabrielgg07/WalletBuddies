//
//  Tab1View.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct AccountTabView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var isDeleted : Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                
                Button("Log Out") {
                    auth.signOut()
                }
                .buttonStyle(.bordered)
                
                Button("Delete Account") {
                    isDeleted = true
                }
                .buttonStyle(.bordered)
                
                    
                    // You can add more account-related buttons here:
                    Button("Manage Profile") { /* TODO */ }
                    Button("Security Settings") { /* TODO */ }
                    Text("Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim.Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Backup Phrase and a lot of just gibbereish cuz i want ot make it lonfer, Lorem Ipsum si et dolorom. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor quam id massa faucibus dignissim. Nullam eget metus id nisl malesuada condimentum. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim. Nam viverra fringilla erat, ut fermentum nunc feugiat eu. Quisque viverra elit eget eros faucibus dignissim.   ")
                }.navigationDestination(isPresented: $isDeleted){
                    LoginView()
                }
                .padding()
            }
        }
    }



#Preview {
    NavigationStack{
        AccountTabView()
            .environmentObject(AuthManager()) // injects a fresh instance
    }
}

