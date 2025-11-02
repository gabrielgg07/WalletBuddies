import SwiftUI

// MARK: Possible quests
// list of possible quests
private let allQuestTemplates: [QuestTemplate] = [
    QuestTemplate(id: UUID(), title: "Track 3 expenses", description: "Add three new expenses to your log.", rewardXP: 50),
    QuestTemplate(id: UUID(), title: "Add 3 goals", description: "Set three new savings goals.", rewardXP: 100),
    QuestTemplate(id: UUID(), title: "Read something for 5 minutes", description: "Read one of our financial articles for 5 minutes.", rewardXP: 75),
    QuestTemplate(id: UUID(), title: "Invite a friend", description: "Share WalletBuddies with a friend.", rewardXP: 150)
]

import SwiftUI

// MARK: Home View
struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var xpSystem = XPSystem(currentXp: 40, level: 1)
    @State private var showGoalsList = false
    @State private var selectedGoal: SavingsGoal?
    @State private var showGoalDetail = false
    @State private var showQuests = false
    @StateObject private var questManager: QuestManager
    
    init() {
        _questManager = StateObject(wrappedValue: QuestManager(userID: "user123", questTemplates: allQuestTemplates))
    }
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                
                // === XP Section ===
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

                Spacer()
                

                Spacer()

                // === Tab view ===
                TabView {
                    HomeTabView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                    TransactionsTabView()
                        .tabItem { Label("Transactions", systemImage: "clock.arrow.circlepath") }
                    PlantTabView()
                        .tabItem { Label("Plants", systemImage: "leaf.fill") }
                    GoalsTabView()
                        .tabItem { Label("Goals", systemImage: "target") }
                    AccountTabView()
                        .tabItem { Label("Settings", systemImage: "person.crop.circle") }
                        .environmentObject(auth)
                }
                .tint(.green)
            }

            // === Quest button (now higher & to the right) ===
            Button(action: { showQuests = true }) {
                Image(systemName: "scroll.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.green)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            // slightly lower right padding so it’s visible but not cut off
            .padding(.trailing, 50)
            // pull it up a bit more
            .padding(.top, -40)
        }
        .overlay(
            // Quests popup overlay
            Group {
                if showQuests {
                    QuestsPopupView(isPresented: $showQuests, quests: questManager.quests)
                        .zIndex(5)
                }
               
                
            }
        )
    }
}



#Preview {
    HomeView()
    .environmentObject(AuthManager())  // supply a dummy instance
}
