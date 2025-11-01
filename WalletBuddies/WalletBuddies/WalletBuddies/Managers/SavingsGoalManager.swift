//
//  SavingsGoalManager.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/1/25.
//


import Foundation
import Combine

class SavingsGoalManager: ObservableObject {
    @Published var goals: [SavingsGoal] = []

    private let userId: String

    init(userId: String) {
        self.userId = userId
        loadGoals()
        
        // Only add default/demo goal if no goals loaded
        if goals.isEmpty {
            addGoal(title: "Motorcycle", target: 10000)
        }
    }

    func addGoal(title: String, target: Double) {
        // Prevent adding duplicate demo goal
        if goals.contains(where: { $0.title == title }) { return }
        let newGoal = SavingsGoal(id: UUID(), title: title, targetAmount: target, contributed: 0)
        goals.append(newGoal)
        saveGoals()
        
        
    }
    
    func removeGoal(_ goal: SavingsGoal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }

    func contribute(to goal: SavingsGoal, amount: Double) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index].contributed += amount
        saveGoals()
    }

    // MARK: - Persistence (UserDefaults demo, replace with DB later)
    private func storageKey() -> String {
        return "savingsGoals_\(userId)"
    }

    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: storageKey())
        }
    }

    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: storageKey()) {
                let decoder = JSONDecoder()
            if let loadedGoals = try? decoder.decode([SavingsGoal].self, from: data) {
                // Deduplicate by title or id
                let uniqueGoals = Array(Set(loadedGoals)) // if SavingsGoal: Equatable & Hashable
                self.goals = uniqueGoals
                return
            }
        }
        self.goals = []
    }
    
    
}
