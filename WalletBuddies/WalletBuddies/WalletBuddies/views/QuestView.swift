//
//  questView.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/1/25.
//

import SwiftUI



// MARK: - QUEST CARD
// QuestCardView: the information of a quest on a card. used by the quests popup to display all of a user's quests
struct QuestCardView: View {
    let quest: QuestTemplate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // title of quest
            Text(quest.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            // description of quest
            Text(quest.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            // xp amount
            HStack {
                Spacer()
                Label("\(quest.rewardXP) XP", systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

// MARK: - QUESTS POPUP
// QuestsPopupView: the popup that shows the user's quests
struct QuestsPopupView: View {
    @Binding var isPresented: Bool
    let quests: [QuestTemplate]
    
    var body: some View {
        ZStack {
            // dim background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    // closes the popup
                    Button(action: {isPresented = false}) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 12)
                
                Text("Daily Quests")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 5)
                // allows for scrolling in the quests pop up
                ScrollView {
                    VStack(spacing: 10) {
                        // draws the quest card for each quest given to a user
                        ForEach(quests) { quest in
                            QuestCardView(quest: quest)
                        }
                    }
                }
                .padding()
            }
            .frame(width: 350, height: 500)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()
            .transition(.scale)
        }
        // animation for the card
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}
