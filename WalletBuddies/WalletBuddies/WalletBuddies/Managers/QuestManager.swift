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
    @Published var dailyQuests: [ActiveQuest]
    @Published var monthlyQuests: [ActiveQuest]
    @Published var completedQuestReward: Int? = nil
    // userId
    private var userId: String
    // array of QuestTemplate (s)
    private let dailyTemplates: [QuestTemplate]
    private let monthlyTemplates: [QuestTemplate]
    // number of quests for a user
    private let questCount = 3

    // MARK: - Init : runs first time loading operations
    init(userID: String, dailyTemplates: [QuestTemplate], monthlyTemplates: [QuestTemplate]) {
        self.userId = userID
        self.dailyTemplates = dailyTemplates
        self.monthlyTemplates = monthlyTemplates
        self.dailyQuests = []
        self.monthlyQuests = []
        loadFromStorage()
        
        refreshDailyIfNeeded()
        refreshMonthlyIfNeeded()
    }
    func completeQuest(_ quest: ActiveQuest) {
        completedQuestReward = quest.rewardXP
    }
    func updateUserId(_ newUserId: String) {
        self.userId = newUserId
    }
    func refreshDailyIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if dailyQuests.isEmpty || dailyQuests.first!.assignedDate < today {
            assignNewDailyQuests()
        }
    }
    private func assignNewDailyQuests() {
        dailyQuests = dailyTemplates.shuffled().prefix(3).map { template in
            ActiveQuest(
                id: UUID().uuidString,
                title: template.title,
                description: template.description,
                templateId: template.id.uuidString,
                rewardXP: template.rewardXP,
                assignedDate: Date(),
                expirationDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                progress: 0,
                isCompleted: false
            )
        }
        saveToStorage()
    }
    
    func refreshMonthlyIfNeeded() {
        let now = Date()
        let comps = Calendar.current.dateComponents([.year,.month], from: now)
        let firstDay = Calendar.current.date(from: comps)!
        if monthlyQuests.isEmpty || monthlyQuests.first!.assignedDate < firstDay {
            assignNewMonthlyQuests(for: firstDay)
        }
    }
    private func assignNewMonthlyQuests(for firstDay: Date) {
        monthlyQuests = monthlyTemplates.map { template in
            let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: firstDay)!
            return ActiveQuest(
                id: UUID().uuidString,
                title: template.title,
                description: template.description,
                templateId: template.id.uuidString,
                rewardXP: template.rewardXP,
                assignedDate: firstDay,
                expirationDate: nextMonth,
                progress: 0,
                isCompleted: false
            )
        }
        saveToStorage()
    }
    
    func registerEvent(_ event: QuestEvent) {
        update(event: event, for: &dailyQuests)
        update(event: event, for: &monthlyQuests)
        saveToStorage()
    }
    
    private func update(event: QuestEvent, for quests: inout [ActiveQuest]) {
        for i in quests.indices {
            if quests[i].isCompleted { continue }
            guard let template = templateFor(id: quests[i].templateId) else {continue}
            switch (template.type, event) {
            case (.visitView, .visitView):
                quests[i].progress += 1
                
            case (.contribute, .contribute(let amount)):
                quests[i].progress += amount
                
            case (.timeActive, .timeActive(let seconds)):
                quests[i].progress += Double(seconds)
                
            default:
                continue
            }
            
            if let target = template.targetValue, quests[i].progress >= target {
                quests[i].isCompleted = true
                quests[i].progress = target
                completeQuest(quests[i])
            }
        }
    }
    
    private func templateFor(id: String) -> QuestTemplate? {
        (dailyTemplates + monthlyTemplates).first { $0.id.uuidString == id}
    }
    
    func saveToStorage() {
        let encoder = JSONEncoder()
        if let encodedDaily = try? encoder.encode(dailyQuests) {
            UserDefaults.standard.set(encodedDaily,forKey: "dailyQuests_\(userId)")
            
        }
        if let encodedMonthly = try? encoder.encode(monthlyQuests) {
            UserDefaults.standard.set(encodedMonthly,forKey: "monthlyQuests_\(userId)")
        }
        
    }
    
    func loadFromStorage() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: "dailyQuests_\(userId)"),
           let decoded = try? decoder.decode([ActiveQuest].self, from: savedData) {
            self.dailyQuests = decoded
        }
        
        if let savedData = UserDefaults.standard.data(forKey: "monthlyQuests_\(userId)"),
           let decoded = try? decoder.decode([ActiveQuest].self, from: savedData) {
            self.monthlyQuests = decoded
        }
        
    }
    
}
