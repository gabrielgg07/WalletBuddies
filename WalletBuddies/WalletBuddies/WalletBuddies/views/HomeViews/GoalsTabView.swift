//
//  GoalsTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//  Edited by Walter Pereira Cruz on 11/01/25.
//

import SwiftUI
// GoalRowView: contains verything related to the row of a goal. Title, current amount, and goal amount
struct GoalRowView: View {
    // the goal. type SavingsGoal
    var goal: SavingsGoal

    var body: some View {
        // Horiontal management of items
        HStack {
            // title
            Text(goal.title)
                .font(.headline)
            Spacer()
            // contribution over target amount
            Text("\(Int(goal.contributed))/\(Int(goal.targetAmount))")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
// bottom of the view where a goal can be added. Needs title and amount
struct AddGoalSectionView: View {
    // manages goals. need to add goals
    @ObservedObject var goalManager: SavingsGoalManager
    @Binding var newGoalTitle: String
    @Binding var newGoalTarget: Double?

    var body: some View {
        VStack(spacing: 10) {
            // Title can be whatever
            TextField("Goal Title", text: $newGoalTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            // Target Amount must be a number
            TextField("Target Amount", value: $newGoalTarget, format: .number)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            // button confirms the addition and also updates the database
            Button(action: {
                if let target = newGoalTarget, !newGoalTitle.isEmpty {
                    goalManager.addGoal(title: newGoalTitle, target: target)
                    newGoalTitle = ""
                    newGoalTarget = nil
                }
            }) {
                // text inside the button
                Text("Add Goal")
                    .frame(maxWidth: .infinity)
            }
            // makes button rounded and green
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .padding(.horizontal)
        }
        // some stuff to make the add section look better
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


// GoalsTabView: The view for the page. Combines all of the different views together
struct GoalsTabView: View {
    // manager for goals. used for seeing the goals of the user
    @StateObject private var goalManager: SavingsGoalManager
    // selected goal for popup
    @State private var selectedGoal: SavingsGoal?
    // popup variable
    @State private var showGoalDetail = false
    // add goal title variable
    @State private var newGoalTitle: String = ""
    // add goal target variable
    @State private var newGoalTarget: Double? = nil
    // runs on the first when opening view. used for demo. will be replaced with actual data acquiring
    init() {
        _goalManager = StateObject(wrappedValue: SavingsGoalManager(userId: "user123"))
    }
    
    var body: some View {
        VStack {
            Text("Your Goals")
                .font(.title2)
                .padding(.top)
            // allows for scrolling if many goals
            ScrollView {
                VStack(spacing: 10) {
                    // creates another goal rectangle button for every goal in the manager
                    ForEach(goalManager.goals) { goal in
                        Button(action: { selectedGoal = goal; showGoalDetail = true }) {
                            GoalRowView(goal: goal)
                        }
                    }
                }
                .padding()
            }

            Divider()

            // the add goal view at the bottom of screen. Allows adding goals to manager and database associated with user
            AddGoalSectionView(goalManager: goalManager, newGoalTitle: $newGoalTitle, newGoalTarget: $newGoalTarget)
        }
        .overlay(
            // Goal Details popup
            Group {
                // the index code allows for when a contribution occurs that the value is updated in the popup.
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
