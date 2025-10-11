//
//  Quest.swift
//  WalletBuddiesXP
//
//  Created by Walter Pereira Cruz on 10/4/25.
//

import Foundation

struct UserQuest: Identifiable, Codable {
    let id: UUID
    let template: QuestTemplate
    var isComplete: Bool = false
    let dateAssigned: Date
    
}
