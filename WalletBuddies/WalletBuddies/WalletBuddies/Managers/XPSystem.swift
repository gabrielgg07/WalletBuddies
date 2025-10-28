//
//  XPSystem.swift
//  WalletBuddiesXP
//
//  Created by Walter Pereira Cruz on 10/4/25.
//

import Foundation

struct XPSystem {
    var currentXp: Int
    var level: Int
    
    mutating func addXP(_ amount: Int) -> Bool {
        var leveledup = false
        currentXp += amount
        while currentXp >= requiredXP(for: level) {
            currentXp -= requiredXP(for: level)
            level += 1
            leveledup = true
        }
        return leveledup
    }
    
    func requiredXP(for level: Int) -> Int {
        return 100 * Int(pow(1.5, Double(level - 1)))
    }
    
    func progressPercent() -> Double {
        Double(currentXp) / Double(requiredXP(for: level))
    }
}
