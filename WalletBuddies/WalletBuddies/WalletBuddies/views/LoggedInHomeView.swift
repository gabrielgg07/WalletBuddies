import SwiftUI

// MARK: - Popup View
struct SimplePopupView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            // Popup content
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                // Placeholder content
                Text("Hello, this is a popup!")
                    .font(.headline)
                    .padding()

                Spacer()
            }
            .frame(width: 250, height: 150)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .animation(.easeInOut, value: isPresented)
    }
}

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var xpSystem = XPSystem(currentXp: 40, level: 1)
    @State private var showPopup = false
    @State private var showConfetti = false
    var body: some View {
        VStack(spacing: 10) {
            Text("Level \(xpSystem.level)")
                .font(.headline)

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .cornerRadius(8)

                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.green, .accentColor]),
                        startPoint: .leading,
                        endPoint: .trailing))
                    .frame(width: 300 * xpSystem.progressPercent(), height: 20)
                    .cornerRadius(8)
                    .animation(.easeInOut, value: xpSystem.progressPercent())
            }
            .frame(width: 300)

            Text("\(xpSystem.currentXp)/\(xpSystem.requiredXP(for: xpSystem.level)) XP")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .zIndex(1) // Keeps it on top of scroll content
        Button("Open Popup") {
            showPopup = true
        }
        .padding()
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
        if showPopup {
            SimplePopupView(isPresented: $showPopup)
        }
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


#Preview {
    HomeView()
        .environmentObject(AuthManager())   // supply a dummy instance
        
}
