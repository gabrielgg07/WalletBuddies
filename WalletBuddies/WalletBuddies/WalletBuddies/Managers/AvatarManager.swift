//
//  AvatarManager.swift
//  WalletBuddies
//
//  Created by lending on 11/18/25.
//

import Foundation
import SwiftUI

let allAvatars: [Avatar] = [
    Avatar(id: 1, name: "Leaf", imageName: "leaf", requiredLevel: 1),
    Avatar(id: 2, name: "Tree", imageName: "tree", requiredLevel: 3),
    Avatar(id: 3, name: "Bear", imageName: "teddybear", requiredLevel: 5),
]

class AvatarManager: ObservableObject {
    @Published var unlockedAvatarIds: Set<Int> = []
    @Published var selectedAvatarId: Int?
    
    private var userId: Int
    
    init(userId: Int) {
        self.userId = userId
        load()
        unlockEligibleAvatars(currentLevel: XPSystem.load(for: userId).level)
    }
    
    func unlockEligibleAvatars(currentLevel: Int) {
        let newlyUnlocked = allAvatars.filter { $0.requiredLevel <= currentLevel}
        let newIDs = newlyUnlocked.map {$0.id}
        unlockedAvatarIds.formUnion(newIDs)
        save()
    }
    func updateId(_ userId: Int) {
        self.userId = userId
    }
    func selectAvatar(_ id: Int) {
        if unlockedAvatarIds.contains(id) {
            selectedAvatarId = id
            save()
        }
    }
    
    func save() {
        let data = [
            "unlocked": Array(unlockedAvatarIds),
            "selected": selectedAvatarId as Any
        ] as [String: Any]
        
        UserDefaults.standard.set(data, forKey: "\(userId)_avatar_data")
    }
    
    func load() {
        if let data = UserDefaults.standard.dictionary(forKey: "\(userId)_avatar_data") {
            if let unlocked = data["unlocked"] as? [Int] {
                unlockedAvatarIds = Set(unlocked)
            }
            if let selected = data["selected"] as? Int {
                selectedAvatarId = selected
            }
        } else {
            unlockedAvatarIds = [1]
            selectedAvatarId = 1
        }
    }
}
