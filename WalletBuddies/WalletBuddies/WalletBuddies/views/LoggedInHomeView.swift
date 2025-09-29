import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        TabView {
            // --- First Tab: Home ---
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            // --- Second Tab: Transactions ---
            TransactionsTabView()
                .tabItem {
                    Label("Transactions", systemImage: "clock.arrow.circlepath")
                }
            // --- Third Tab: Plants ---
            PlantTabView()
                .tabItem {
                    Label("Plants", systemImage: "leaf.fill")
                }
            
            // --- Fourth Tab: savings goals ---
            GoalsTabView()
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
        .tint(.green)   // 👈 active tab icon/text will be green
    }
}


