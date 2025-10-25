//
//  QuestManager.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 10/4/25.
//
// not working right now. must decide where to take this. everyone has their own random quests or everyone shares the same random quests daily
import Foundation
import Combine

@MainActor
class QuestManager: ObservableObject {
    @Published var quests: [QuestTemplate] = []        // Daily quests for today
    @Published var completedQuestIDs: [UUID] = []      // Only store completed IDs

    private let userId: String
    private let questTemplates: [QuestTemplate]
    private let questCount = 3

    // MARK: - Init
    init(userID: String, questTemplates: [QuestTemplate]) {
        self.userId = userID
        self.questTemplates = questTemplates
        loadGenerateDailyQuests()
    }

    // MARK: - Daily Quest Generation
    func loadGenerateDailyQuests() {
        let today = Calendar.current.startOfDay(for: Date())

        // Load from storage if already generated today
        if let savedIDs = loadStoredCompletedIDs(),
           let lastAssignedDate = UserDefaults.standard.object(forKey: "dailyQuestsDate_\(userId)") as? Date,
           Calendar.current.isDate(today, inSameDayAs: lastAssignedDate) {
            self.completedQuestIDs = savedIDs
            self.quests = Array(questTemplates.shuffled().prefix(questCount))
            return
        }

        // Pick new daily quests
        let selected = Array(questTemplates.shuffled().prefix(questCount))
        self.quests = selected
        self.completedQuestIDs = []

        // Save today's date for daily reset
        UserDefaults.standard.set(today, forKey: "dailyQuestsDate_\(userId)")
        saveCompletedIDs()
    }

    // MARK: - Complete Quest
    func completeQuest(_ quest: QuestTemplate) {
        if !completedQuestIDs.contains(quest.id) {
            completedQuestIDs.append(quest.id)
            saveCompletedIDs()
        }
    }

    func isQuestCompleted(_ quest: QuestTemplate) -> Bool {
        return completedQuestIDs.contains(quest.id)
    }

    // MARK: - Persistence (UserDefaults for demo)
    private func storageKey() -> String {
        return "completedQuests_\(userId)"
    }

    private func saveCompletedIDs() {
        UserDefaults.standard.set(completedQuestIDs, forKey: storageKey())

        // --- Future backend example ---
        /*
        Task {
            // Send completed quest IDs to backend
            // await api.post("/users/\(userId)/completedQuests", body: completedQuestIDs)
        }
        */
    }

    private func loadStoredCompletedIDs() -> [UUID]? {
        return UserDefaults.standard.array(forKey: storageKey()) as? [UUID]
    }
}
