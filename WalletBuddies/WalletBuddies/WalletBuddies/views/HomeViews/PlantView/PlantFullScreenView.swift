//
//  PlantFullScreenView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/28/25.
//

import SwiftUI

struct PlantFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthManager

    @State private var monthlySpending: Double = 0
    @State private var isLoading = true

    private let levelRequirement: Double = 2000  // Points needed for next level
    
    var progress: Double {
        min(monthlySpending / levelRequirement, 1.0)
    }
    
    var pointsRemaining: Double {
        max(levelRequirement - monthlySpending, 0)
    }
    
    var body: some View {
        ZStack {
            // 🌈 Background
            LinearGradient(
                colors: [Color.green.opacity(0.35), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {

                // 🔙 Close Button
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.gray.opacity(0.8))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer(minLength: 0)

                // 🌱 Circle Header
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 3)

                    PlantComponent(scale: 0.5)
                }

                Text("Plant Level 1")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 4)

                // 📉 Explanation
                Text("Your financial habits are growing your plant! 🌱")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                // 🧮 Net Value Info
                Group {
                    if isLoading {
                        ProgressView("Fetching net value...")
                            .padding(.top, 10)
                    } else {
                        VStack(spacing: 12) {

                            Text("Current Net Gain")
                                .font(.headline)

                            Text("$\(Int(monthlySpending))")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(monthlySpending >= 0 ? .green : .red)

                            Text("Earn +$2000 total net value to upgrade your plant.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)

                            Text("You are **$\(Int(pointsRemaining))** away from leveling up!")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .padding(.top, 2)
                        }
                    }
                }

                // 🌿 Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.headline)

                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.15))
                            Capsule()
                                .fill(Color.green)
                                .frame(width: geo.size.width * progress)
                                .animation(.easeOut(duration: 0.5), value: progress)
                        }
                    }
                    .frame(height: 16)

                    Text("\(Int(progress * 100))% complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()
                
                // 🌱 Motivational Footer
                Text("Keep saving! Every dollar helps your plant grow 🌿")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 30)
            }
        }
        .onAppear {
            fetchNetValue(auth: auth) { net in
                print("🔥 User net spending:", net)
                monthlySpending = net
                isLoading = false
            }
        }
    }
}
