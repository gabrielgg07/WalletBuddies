//
//  AccountTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var recipient: String
    var subject: String
    var body: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients([recipient])
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}

struct AccountTabView: View {
    @EnvironmentObject var auth: AuthManager
    @State private var showMailView = false
    @State private var showMailError = false

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
                    
                    Button {
                        if MFMailComposeViewController.canSendMail() {
                            showMailView = true
                        } else {
                            showMailView = false
                        }
                    } label: {
                        Label("Contact Admin", systemImage: "envelope.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(.horizontal)
                    
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
        .sheet(isPresented: $showMailView) {
                    MailView(
                        recipient: "nashagober@gmail.com",
                        subject: "User Claim or Support Request",
                        body: "Describe your issue or claim here."
                    )
                }
                .alert("Mail services are not available.", isPresented: $showMailError) {
                    Button("OK", role: .cancel) {}
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
