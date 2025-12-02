//
//  QuestManager.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 10/4/25.
//

import Foundation
import Combine

// QuestManager: manages quests and performs operations that save and load to database. Chooses new quests every day.
@MainActor
class QuestManager: ObservableObject {
    @Published var quests: [QuestTemplate] = []        // Daily quests for today
    @Published var completedQuestIDs: [UUID] = []      // Only store completed IDs
    // userId
    private let userId: String
    // array of QuestTemplate (s)
    private let questTemplates: [QuestTemplate]
    // number of quests for a user
    private let questCount = 3

    // MARK: - Init : runs first time loading operations
    init(userID: String, questTemplates: [QuestTemplate]) {
        self.userId = userID
        self.questTemplates = questTemplates
        loadGenerateDailyQuests()
    }

    // MARK: - Daily Quest Generation : Chooses new quests for the day
    func loadGenerateDailyQuests() {
        let today = Calendar.current.startOfDay(for: Date())

        // Load from storage if already generated today
        if let savedIDs = loadStoredCompletedIDs(),
           // checks for date and whether to assign new quest
           let lastAssignedDate = UserDefaults.standard.object(forKey: "dailyQuestsDate_\(userId)") as? Date,
           Calendar.current.isDate(today, inSameDayAs: lastAssignedDate) {
            self.completedQuestIDs = savedIDs
            // shuffles quests
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

    // MARK: - Complete Quest : completes a quest and saves the completed quest ids
    func completeQuest(_ quest: QuestTemplate) {
        if !completedQuestIDs.contains(quest.id) {
            completedQuestIDs.append(quest.id)
            saveCompletedIDs()
        }
    }
    // checks if quest is completed
    func isQuestCompleted(_ quest: QuestTemplate) -> Bool {
        return completedQuestIDs.contains(quest.id)
    }

    // MARK: - Persistence (UserDefaults for demo)
    private func storageKey() -> String {
        return "completedQuests_\(userId)"
    }
    // will save completed quest ids
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
    // will load completed quest ids
    private func loadStoredCompletedIDs() -> [UUID]? {
        return UserDefaults.standard.array(forKey: storageKey()) as? [UUID]
    }
}
