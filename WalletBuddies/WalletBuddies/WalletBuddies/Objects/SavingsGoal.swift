//
//  SavingsGoal.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 10/25/25.
//

import Foundation
// basic struct for easy access of SavingsGoal variables
struct SavingsGoal: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let title: String
    let targetAmount: Double
    var contributed: Double
}
