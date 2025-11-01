//
//  GoalPopup.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/1/25.
//

import SwiftUI


struct SavingsGoalDetailPopupView: View {
    @Binding var isPresented: Bool
    @ObservedObject var goalManager: SavingsGoalManager
    @Binding var goal: SavingsGoal
    @State private var contributionAmount: Double? = nil

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 20) {
                HStack {
                    Spacer()
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

                    Circle()
                        .trim(from: 0.0, to: min(goal.contributed / goal.targetAmount, 1.0))
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [.green, .blue]), center: .center),
                            style: StrokeStyle(lineWidth: 20, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: goal.contributed)

                    VStack {
                        Text(String(format: "%.0f / %.0f", goal.contributed, goal.targetAmount))
                            .font(.headline)
                        Text(goal.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 180, height: 180)

                // Contribution input
                HStack {
                    TextField("Amount", value: $contributionAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    Button("Contribute") {
                        if let amount = contributionAmount, amount > 0 {
                            goalManager.contribute(to: goal, amount: amount)
                            contributionAmount = nil
                        }
                    }
                    .padding(8)
                    .background(Color.green.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
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
    }
}
