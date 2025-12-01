//
//  GoalPopup.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/1/25.
//

import SwiftUI

// SavingsGoalDetailPopupView: Pop Up used by GoalsTabView that show the details of the SavingsGoal
struct SavingsGoalDetailPopupView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var questManager: QuestManager
    @EnvironmentObject var avatarManager: AvatarManager
    @EnvironmentObject var xpSystemManager: XPSystemManager
    // goalManager
    @ObservedObject var goalManager: SavingsGoalManager
    // selected goal
    @Binding var goal: SavingsGoal
    // variable used for the contribution amount box
    @State private var contributionAmount: Double? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    // button for closing
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                }

                // Circle progress
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.2)
                        .foregroundColor(.green)
                    // fills the circle based on the amount contributed to the goal
                    Circle()
                        .trim(from: 0.0, to: min(goal.contributed / goal.targetAmount, 1.0))
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [.green, .blue]), center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: goal.contributed)

                    VStack {
                        // number in the middle of the circle
                        Text(String(format: "$%.0f / $%.0f", goal.contributed, goal.targetAmount))
                            .font(.headline)
                        // title in the middle of the circle
                        Text(goal.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 180, height: 180)

                // Contribution input
                HStack {
                    // contribution amount inputs only as numbers
                    TextField("Amount", value: $contributionAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    // Confirmation button
                    Button("Contribute") {
                        if let amount = contributionAmount, amount > 0 {
                            goalManager.contribute(to: goal, amount: amount)
//                            questManager.registerEvent(.contribute(amount))
                            contributionAmount = nil
                        }
                    }
                    .padding(8)
                    .background(Color.green.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
//                    .onReceive(questManager.$completedQuestReward) {
//                        reward in guard let xp = reward else { return }
//                        let leveledUp = xpSystemManager.addXP(xp)
//                        questManager.completedQuestReward = nil
//                        if leveledUp {
//                            avatarManager.unlockEligibleAvatars(currentLevel: xpSystemManager.level)
//                            // could add some animation here
//                        }
//                    }
                }
                // --- REMOVE BUTTON ---
                Button(role: .destructive) {
                    goalManager.removeGoal(goal)
                    isPresented = false
                } label: {
                    Text("Remove Goal")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .zIndex(10)
        .onAppear {
            questManager.registerEvent(.visitView("GoalsPopup"))
        }
        .onReceive(questManager.$completedQuestReward) {
            reward in guard let xp = reward else { return }
            let leveledUp = xpSystemManager.addXP(xp)
            questManager.completedQuestReward = nil
            if leveledUp {
                avatarManager.unlockEligibleAvatars(currentLevel: xpSystemManager.level)
                // could add some animation here
            }
        }
    }
}
