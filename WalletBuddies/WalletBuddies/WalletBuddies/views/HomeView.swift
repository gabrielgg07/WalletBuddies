import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        TabView {
            // --- First Tab: Home ---
            Text("Welcome back \(auth.username ?? "")")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            // --- Second Tab: Transactions ---
            Text("No Transactions yet...")
                .tabItem {
                    Label("Transactions", systemImage: "clock.arrow.circlepath")
                }
            // --- Third Tab: Plants ---
            Text("Hm you don't seem to have any plants?")
                .tabItem {
                    Label("Plants", systemImage: "leaf.fill")
                }
            
            // --- Fourth Tab: savings goals ---
            Text("Sorry! Cant set savings goals")
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            // --- Fifth Tab: Settings ---
            AccountTabView()
                .tabItem {
                    Label("Settings", systemImage: "person.crop.circle")
                }
                .environmentObject(auth)
        }
    }
}

#Preview {
    HomeView()
}
