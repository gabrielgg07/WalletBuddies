//
//  SavingsGoalManager.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/1/25.
//


import Foundation
import Combine
// SavingsGoalManager: Manages all goals related to user.
// Allows for contributing, adding, removing, saving, and loading of goals
class SavingsGoalManager: ObservableObject {
    // array filled with SavingsGoal (s)
    @Published var goals: [SavingsGoal] = []
    // userId
    private let userId: String
    // used for demo loads an initial goal and whatever goals are currently stored
    init(userId: String) {
        self.userId = userId
        loadGoals()
        
        // Only add default/demo goal if no goals loaded
        if goals.isEmpty {
            addGoal(title: "Motorcycle", target: 10000)
        }
    }
    // adds goal to the goals array and executes saveGoals
    func addGoal(title: String, target: Double) {
        // Prevent adding duplicate demo goal
        if goals.contains(where: { $0.title == title }) { return }
        let newGoal = SavingsGoal(id: UUID(), title: title, targetAmount: target, contributed: 0)
        goals.append(newGoal)
        // saves the goals array to the database
        saveGoals()
    }
    // removes all goals from the goals array based on the input goal
    // @Param   SavingsGoal goal
    //              A goal input from the goalTab view to remove the goal from the array
    func removeGoal(_ goal: SavingsGoal) {
        // removes all goals with the id of the goal input
        goals.removeAll { $0.id == goal.id }
        // saves the array of goals without the removed one
        saveGoals()
    }
    //  increases the contributed amount of a SavingsGoal by amount
    //  @Param  SavingsGoal goal
    //              the goal to be contributed to
    //  @Param  Double amount
    //              the amount to be added to the contribution amount
    func contribute(to goal: SavingsGoal, amount: Double) {
        // finds the goal
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        // adds amount to goal
        goals[index].contributed += amount
        // saves goals to database
        saveGoals()
    }

    // MARK: - Persistence (UserDefaults demo, replace with DB later)
    private func storageKey() -> String {
        return "savingsGoals_\(userId)"
    }
    // saves goals to database. eventually not currently saving to DB
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: storageKey())
        }
    }
    // loads goals to database. eventually not currently loading from DB
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: storageKey()) {
                let decoder = JSONDecoder()
            if let loadedGoals = try? decoder.decode([SavingsGoal].self, from: data) {
                // Deduplicate by title or id
                let uniqueGoals = Array(Set(loadedGoals))
                self.goals = uniqueGoals
                return
            }
        }
        self.goals = []
    }
}
