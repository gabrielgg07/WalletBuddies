//
//  Quest.swift
//  WalletBuddiesXP
//
//  Created by Walter Pereira Cruz on 10/4/25.
//

import Foundation

struct QuestTemplate: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let rewardXP: Int
}
