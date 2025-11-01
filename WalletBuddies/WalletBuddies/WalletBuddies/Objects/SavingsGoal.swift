//
//  SavingsGoal.swift
//  WalletBuddies
//
//  Created by lending on 10/25/25.
//

import Foundation

struct SavingsGoal: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let title: String
    let targetAmount: Double
    var contributed: Double
}
