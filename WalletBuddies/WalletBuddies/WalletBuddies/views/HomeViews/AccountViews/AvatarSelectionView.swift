//
//  AvatarSelectionView.swift
//  WalletBuddies
//
//  Created by Walter Pereira Cruz on 11/18/25.
//
import SwiftUI
import Foundation

struct AvatarTileView: View {
    let avatar: Avatar
    @ObservedObject var avatarManager: AvatarManager

    var body: some View {
        VStack {
            Image(avatar.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .opacity(avatarManager.unlockedAvatarIds.contains(avatar.id) ? 1 : 0.3)
                .overlay(
                    Group {
                        if avatarManager.selectedAvatarId == avatar.id {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 3)
                        }
                    }
                )
                .onTapGesture {
                    avatarManager.selectAvatar(avatar.id)
                }

            Text("Lvl \(avatar.requiredLevel)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}



struct AvatarSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var avatarManager: AvatarManager

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Choose Your Avatar")
                            .font(.title2)
                            .bold()

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                            ForEach(allAvatars) { avatar in
                                AvatarTileView(
                                    avatar: avatar,
                                    avatarManager: avatarManager
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(.leading, 16)
                        .padding(.top, 12)
                    }
                    .ignoresSafeArea(.container, edges: .top)
    }
}
