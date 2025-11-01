//
//  GoalsTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//  Edited by Walter Pereira Cruz on 11/01/25.
//

import SwiftUI

struct GoalRowView: View {
    var goal: SavingsGoal

    var body: some View {
        HStack {
            Text(goal.title)
                .font(.headline)
            Spacer()
            Text("\(Int(goal.contributed))/\(Int(goal.targetAmount))")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct AddGoalSectionView: View {
    @ObservedObject var goalManager: SavingsGoalManager
    @Binding var newGoalTitle: String
    @Binding var newGoalTarget: Double?

    var body: some View {
        VStack(spacing: 10) {
            TextField("Goal Title", text: $newGoalTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Target Amount", value: $newGoalTarget, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                if let target = newGoalTarget, !newGoalTitle.isEmpty {
                    goalManager.addGoal(title: newGoalTitle, target: target)
                    newGoalTitle = ""
                    newGoalTarget = nil
                }
            }) {
                Text("Add Goal")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}



struct GoalsTabView: View {
    @StateObject private var goalManager: SavingsGoalManager
    @State private var selectedGoal: SavingsGoal?
    @State private var showGoalDetail = false
    @State private var newGoalTitle: String = ""
    @State private var newGoalTarget: Double? = nil

    init() {
        _goalManager = StateObject(wrappedValue: SavingsGoalManager(userId: "user123"))
    }
    
    var body: some View {
        VStack {
            Text("Your Goals")
                .font(.title2)
                .padding(.top)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(goalManager.goals) { goal in
                        Button(action: { selectedGoal = goal; showGoalDetail = true }) {
                            GoalRowView(goal: goal)
                        }
                    }
                }
                .padding()
            }

            Divider()

            
            AddGoalSectionView(goalManager: goalManager, newGoalTitle: $newGoalTitle, newGoalTarget: $newGoalTarget)
        }
        .overlay(
            // Detail popup
            Group {
                if showGoalDetail, let index = goalManager.goals.firstIndex(where: { $0.id == selectedGoal!.id }) {
                    SavingsGoalDetailPopupView(isPresented: $showGoalDetail, goalManager: goalManager, goal: $goalManager.goals[index])
                }
            }
        )
    }
}

#Preview {
    GoalsTabView()
}
