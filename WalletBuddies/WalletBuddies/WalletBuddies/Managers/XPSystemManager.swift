//
//  XPSystemManager.swift
//  WalletBuddiesXP
//
//  Created by Walter Pereira Cruz on 11/4/25.
//

import Foundation
// XPSystem: Is used for easily accesing and updating the experience of a user. Uses an exponential formula for xp required per level
class XPSystemManager: ObservableObject {
    // min amount of variables
    // currentXp amount
    @Published var currentXp: Int
    // user's current level
    @Published var level: Int
    var userId: Int
    
    init(userId: Int) {
        self.userId = userId
        let saved  = XPSystem.load(for: userId)
        self.level = saved.level
        self.currentXp = saved.currentXp
    }
    func setUser(_ userId: Int) {
        self.userId = userId
        let saved  = XPSystem.load(for: userId)
        self.level = saved.level
        self.currentXp = saved.currentXp
    }
    
    // adds xp to current xp and checks if the next level was reached. If so then reset current xp and add a level
    @discardableResult
    func addXP(_ amount: Int) -> Bool {
        var leveledup = false
        currentXp += amount
        while currentXp >= requiredXP(for: level) {
            currentXp -= requiredXP(for: level)
            level += 1
            leveledup = true
        }
        save()
        // used for an effect
        return leveledup
    }
    // calculates the required xp for the next level
    func requiredXP(for level: Int) -> Int {
        return 100 * Int(pow(1.5, Double(level - 1)))
    }
    // converts progress to a percent
    func progressPercent() -> Double {
        Double(currentXp) / Double(requiredXP(for: level))
    }
    func save() {
        let system = XPSystem(currentXp: currentXp, level: level)
        system.save(for: userId)
    }
}
