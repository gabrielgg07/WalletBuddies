//
//  Quest.swift
//  WalletBuddiesXP
//
//  Created by Walter Pereira Cruz on 10/4/25.
//

import Foundation
enum QuestType: String, Codable {
    case visitView
    case contribute
    case timeActive
}

enum QuestEvent{
    case visitView(String)
    case contribute(Double)
    case timeActive(Int)
}
// template of quests
struct QuestTemplate: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let rewardXP: Int
    let type: QuestType
    
    let targetValue: Double?
}

struct ActiveQuest: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let templateId: String
    let rewardXP: Int
    let assignedDate: Date
    let expirationDate: Date
    var progress: Double
    var isCompleted: Bool
    
}
