//
//  AccountPlaceholders.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/3/25.
//

import SwiftUI

// MARK: - Base Template
struct AccountPlaceholderTemplate<Content: View>: View {
    var title: String
    var systemImage: String
    @ViewBuilder var content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint.opacity(0.25), .white],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // MARK: Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text(title)
                        .font(.title2.bold())
                    Spacer()
                    Image(systemName: systemImage)
                        .foregroundColor(.accentColor)
                        .font(.title3)
                        .opacity(0.8)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // MARK: Content Card
                VStack(spacing: 16) {
                    content()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(radius: 4)
                )
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

// MARK: - Individual Screens
struct EditProfileView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Edit Profile", systemImage: "person.text.rectangle") {
            Text("Customize your name, username, and photo.")
                .font(.subheadline)
                .foregroundColor(.gray)
            Button("Edit Profile Info") {}
                .buttonStyle(.borderedProminent)
        }
    }
}

struct SecuritySettingsView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Security Settings", systemImage: "lock.shield") {
            Text("Manage password, 2FA, and login alerts.")
                .foregroundColor(.gray)
            Button("Manage Security") {}
                .buttonStyle(.borderedProminent)
                .tint(.red)
        }
    }
}

struct NotificationsView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Notifications", systemImage: "bell") {
            Toggle("Push Notifications", isOn: .constant(true))
            Toggle("Email Updates", isOn: .constant(false))
            Toggle("Budget Alerts", isOn: .constant(true))
        }
        .padding(.horizontal)
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Payment Methods", systemImage: "creditcard") {
            Text("Connect a card or bank to manage your transfers.")
                .foregroundColor(.gray)
            Button("Add Payment Method") {}
                .buttonStyle(.borderedProminent)
                .tint(.blue)
        }
    }
}

struct BackupSyncView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Backup & Sync", systemImage: "arrow.triangle.2.circlepath") {
            Text("Your data is automatically backed up to the cloud.")
                .foregroundColor(.gray)
            Button("Sync Now") {}
                .buttonStyle(.borderedProminent)
                .tint(.green)
        }
    }
}

struct PreferencesView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Preferences", systemImage: "gearshape") {
            Picker("Theme", selection: .constant("Light")) {
                Text("Light").tag("Light")
                Text("Dark").tag("Dark")
            }
            .pickerStyle(.segmented)
            Toggle("Show Tips", isOn: .constant(true))
        }
        .padding(.horizontal)
    }
}

struct HelpSupportView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Help & Support", systemImage: "questionmark.circle") {
            Text("Need assistance? We're here to help.")
                .foregroundColor(.gray)
            Button("Contact Support") {}
                .buttonStyle(.borderedProminent)
        }
    }
}

struct TermsPrivacyView: View {
    var body: some View {
        AccountPlaceholderTemplate(title: "Terms & Privacy", systemImage: "doc.text") {
            Text("Read how we protect your data and privacy.")
                .foregroundColor(.gray)
            Button("View Terms") {}
                .buttonStyle(.bordered)
            Button("View Privacy Policy") {}
                .buttonStyle(.bordered)
        }
    }
}


