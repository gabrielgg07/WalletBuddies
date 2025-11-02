//
//  AccountTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct AccountTabView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // MARK: - Header Section
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top, 20)

                    Text("Gabriel Gonzalez")
                        .font(.title2.bold())

                    Text("gabriel@example.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Divider()
                    .padding(.horizontal)

                // MARK: - Account Info Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Profile")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        accountRow(icon: "person.text.rectangle", title: "Edit Profile")
                        accountRow(icon: "lock.shield", title: "Security Settings")
                        accountRow(icon: "bell", title: "Notifications")
                        accountRow(icon: "creditcard", title: "Payment Methods")
                        accountRow(icon: "arrow.triangle.2.circlepath", title: "Backup & Sync")
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - App Settings Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Settings")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        accountRow(icon: "gearshape", title: "Preferences")
                        accountRow(icon: "questionmark.circle", title: "Help & Support")
                        accountRow(icon: "doc.text", title: "Terms & Privacy")
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }

                // MARK: - Buttons
                VStack(spacing: 12) {
                    Button(role: .destructive) {
                        auth.deleteAccount()
                    } label: {
                        Text("Delete Account")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.horizontal)

                    Button {
                        auth.signOut()
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Reusable Row Component
    private func accountRow(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            Text(title)
                .font(.subheadline)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        AccountTabView()
            .environmentObject(AuthManager())
    }
}
