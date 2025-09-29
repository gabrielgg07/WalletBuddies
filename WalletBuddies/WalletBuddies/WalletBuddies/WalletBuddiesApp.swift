//
//  WalletBuddiesApp.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//

import SwiftUI
import GoogleSignIn

@main
struct WalletBuddiesApp: App {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // removes blur
        appearance.backgroundColor = UIColor.systemGray6  // 👈 pick your color
        appearance.shadowColor = UIColor.separator        // 👈 adds a divider line

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        
        
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: "243679696449-1u67ftc5thcuepbnqj28revb6mph0b2t.apps.googleusercontent.com"
        )
        
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}
