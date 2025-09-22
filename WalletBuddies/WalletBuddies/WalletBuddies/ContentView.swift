//
//  ContentView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/22/25.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}


// Example subviews
struct HomeView: View {
    var body: some View {
        Text("This is the Home tab")
            .font(.title)
            .padding()
    }
}

struct SettingsView: View {
    var body: some View {
        Text("This is the Settings tab")
            .font(.title)
            .padding()
    }
}


#Preview {
    ContentView()
}
