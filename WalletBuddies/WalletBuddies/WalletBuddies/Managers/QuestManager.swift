//
//  QuestManager.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 10/4/25.
//
// not working right now. must decide where to take this. everyone has their own random quests or everyone shares the same random quests daily
import Foundation
import Combine

class QuestManager: ObservableObject {
    @Published var quests: [UserQuest] = []
    //let questPool: [Quest] = [Quest(title: "Track 3 expenses", description: "Add three new expenses to log", rewardXP: 50),
    //    Quest(title: "Add 3 goals", description: "Add three new goals to track", rewardXP: 100),
    //    Quest(title: "Read something for 5 minutes", description: "Read one of our articles for 5 minutes", rewardXP: 450)]
    private let userId: String
    private let questTemplates: [QuestTemplate]
    private let questCount = 3
    
    init(userID: String, questTemplates: [QuestTemplate]) {
        self.userId = userID
        self.questTemplates = questTemplates
        loadGenerateDailyQuests()
    }
    func loadGenerateDailyQuests() {
        let today = Calendar.current.startOfDay(for: Date())
        if let saveQuests = loadStoredQuests(), saveQuests.first?.dateAssigned == today {
            self.quests = saveQuests
            return
        }
        let selectedQuests = Array(questTemplates.shuffled().prefix(questCount))
        let newQuests = selectedQuests.map {template in UserQuest(id: UUID(), template: template, isComplete: false, dateAssigned: today)
        }
        self.quests = newQuests
        saveQuestsInStorage(newQuests)
    }
    
    func completeQuest(_ quest: UserQuest) {
        if let index = quests.firstIndex(where: { $0.id == quest.id}) {
            quests[index].isComplete = true
            saveQuestsInStorage(quests)
        }
    }
    // MARK: - Persistence (UserDefaults for demo)
    
    private func storageKey() -> String {
        return "dailyQuests_\(userId)"
    }
    
    private func saveQuestsInStorage(_ quests: [UserQuest]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(quests) {
            UserDefaults.standard.set(encoded, forKey: storageKey())
        }
    }
    
    private func loadStoredQuests() -> [UserQuest]? {
        guard let data = UserDefaults.standard.data(forKey: storageKey()) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([UserQuest].self, from: data)
    }
}
