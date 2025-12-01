//
//  OnboardingView.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/18/25.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var page = 0

    var body: some View {
        TabView(selection: $page) {
            
            // --- PAGE 1 ---
            OnboardingPage(
                title: "Welcome to WalletBuddies",
                subtitle: "Track savings, earn XP, complete quests, and level up!",
                image: "sparkles"
            )
            .tag(0)

            // --- PAGE 2 ---
            OnboardingPage(
                title: "Daily & Monthly Quests",
                subtitle: "Complete challenges to earn rewards and stay motivated.",
                image: "flag.checkered"
            )
            .tag(1)

            // --- PAGE 3 ---
            OnboardingPage(
                title: "Grow Your Avatar",
                subtitle: "Earn XP, unlock avatars, and show off your progress!",
                image: "person.crop.circle.fill.badge.checkmark"
            )
            .tag(2)
        }
        .tabViewStyle(.page)
        .overlay(alignment: .bottom) {
            if page == 2 {
                Button(action: { dismiss() }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
                .transition(.opacity)
            }
        }
        .background(.ultraThinMaterial)
    }
}

struct OnboardingPage: View {
    var title: String
    var subtitle: String
    var image: String

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: image)
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .padding(.bottom, 20)

            Text(title)
                .font(.largeTitle.weight(.bold))
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            Spacer()
        }
    }
}
