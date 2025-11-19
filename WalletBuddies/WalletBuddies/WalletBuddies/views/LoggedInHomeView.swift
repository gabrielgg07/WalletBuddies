import SwiftUI

// MARK: Possible quests
// list of possible quests
private let dailyQuestTemplates: [QuestTemplate] = [
    QuestTemplate(id: UUID(), title: "Spend 5 Minutes on the app", description: "Interact with WalletBuddies for 5 minutes.", rewardXP: 50, type: .timeActive, targetValue: 300),
    QuestTemplate(id: UUID(), title: "Contribute to a goal", description: "Contribute some amount to a savings goals.", rewardXP: 50, type: .contribute, targetValue: 1),
    QuestTemplate(id: UUID(), title: "Visit your plant view", description: "Check out how your plant is doing.", rewardXP: 50, type: .visitView, targetValue: 1)
]
private let monthlyQuestTemplates: [QuestTemplate] = [
    QuestTemplate(id: UUID(), title: "Spend 30 Minutes on the app", description: "Interact with WalletBuddies for 30 minutes.", rewardXP: 300, type: .timeActive, targetValue: 1800),
    QuestTemplate(id: UUID(), title: "Contribute to three goals", description: "Contribute some amount to three savings goals.", rewardXP: 300, type: .contribute, targetValue: 3),
    QuestTemplate(id: UUID(), title: "Visit your plant view", description: "Check out how your plant is doing.", rewardXP: 300, type: .visitView, targetValue: 10)
]



// MARK: Home View
struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    @StateObject var xpSystemManager = XPSystemManager(userId: 0)
    @State private var showGoalsList = false
    @State private var selectedGoal: SavingsGoal?
    @State private var showGoalDetail = false
    @State private var showQuests = false
    @StateObject private var questManager = QuestManager(userID: "0", dailyTemplates: dailyQuestTemplates, monthlyTemplates: monthlyQuestTemplates)
    @StateObject private var avatarManager = AvatarManager(userId: 0)
    @State private var selectedTab = 0
    @State private var showOnboarding = false
    @State private var showPlantFullscreen = false
    @State private var startTime = Date()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                
                // === XP Section ===
                if selectedTab != 2 {
                    VStack(spacing: 10) {
                        Text("Level \(xpSystemManager.level)")
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
                                .frame(width: 300 * xpSystemManager.progressPercent(), height: 20)
                                .cornerRadius(8)
                                .animation(.easeInOut, value: xpSystemManager.progressPercent())
                        }
                        .frame(width: 300)
                        
                        Text("\(xpSystemManager.currentXp)/\(xpSystemManager.requiredXP(for: xpSystemManager.level)) XP")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                
                Spacer()
                
                // === Tab view ===
                TabView(selection: $selectedTab) {
                    HomeTabView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)
                    TransactionsTabView()
                        .tabItem { Label("Transactions", systemImage: "clock.arrow.circlepath") }
                        .tag(1)
                    Color.clear
                        .tabItem { Label("Plants", systemImage: "leaf.fill") }
                        .tag(2)
                    GoalsTabView(userId: auth.userId)
                        .tabItem { Label("Goals", systemImage: "target") }
                        .tag(3)
                        .environmentObject(questManager)
                        .environmentObject(auth)
                        .environmentObject(xpSystemManager)
                        .environmentObject(avatarManager)
                    AccountTabView()
                        .tabItem { Label("Settings", systemImage: "person.crop.circle") }
                        .environmentObject(auth)
                        .tag(4)
                }
                .tint(.green)
            }
            
            // === Quest button (now higher & to the right) ===
            if selectedTab != 2 {
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
                .padding(.top, 70)
            }
        }
        .onAppear {
            let userId = auth.userId
            xpSystemManager.setUser(userId)
            questManager.updateUserId(String(userId))
            avatarManager.updateId(userId)
            startTime = Date()
            if !OnboardingStatus.hasSeen {
                showOnboarding = true
                OnboardingStatus.hasSeen = true
            }
        }
        .onDisappear {
            let seconds = Int(Date().timeIntervalSince(startTime))
            questManager.registerEvent(.timeActive(seconds))
        }
        .onReceive(questManager.$completedQuestReward) {
            reward in guard let xp = reward else { return }
            let leveledUp = xpSystemManager.addXP(xp)
            questManager.completedQuestReward = nil
            if leveledUp {
                avatarManager.unlockEligibleAvatars(currentLevel: xpSystemManager.level)
                // could add some animation here
            }
        }
        .overlay(
            // Quests popup overlay
            Group {
                if showQuests {
                    QuestsPopupView(isPresented: $showQuests, quests: questManager.dailyQuests + questManager.monthlyQuests)
                        .zIndex(5)
                }
               
                
            }
        )
        .fullScreenCover(isPresented: $showPlantFullscreen) {
            PlantTabView()
                .environmentObject(questManager)
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == 2 {
                showPlantFullscreen = true
                selectedTab = 0   // keep UI on Home (optional)
            }
        }

    }
}


// MARK: Admin Home View
struct AdminHomeView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 10) {
                
                // === Tab view ===
                TabView {
                    AdminDatabaseView()
                        .tabItem { Label("Home", systemImage: "house.fill") }
                    AdminAccountView()
                        .tabItem { Label("Settings", systemImage: "person.crop.circle") }
                        .environmentObject(auth)
                }
                .tint(.green)
            }
            
            
            
        }
    }
}

// simple access helper
struct OnboardingStatus {
    static let key = "hasSeenOnboarding"
    static var hasSeen: Bool {
        get { UserDefaults.standard.bool(forKey: key)}
        set { UserDefaults.standard.set(newValue, forKey: key)}
    }
}

#Preview {
    HomeView()
    .environmentObject(AuthManager())  // supply a dummy instance
}
