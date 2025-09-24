//
//  PlaidConnectView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//

import SwiftUI
import LinkKit

struct PlaidConnectView: View {
    var onFinish: () -> Void
    @State private var showPlaid = false
    @State private var linkToken: String?

    var body: some View {
        VStack {
            if linkToken == nil {
                Button("Fetch Link Token") {
                    fetchLinkToken { token in
                        if let token = token {
                            self.linkToken = token
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Open Plaid Link") {
                    showPlaid = true
                }
                .buttonStyle(.borderedProminent)
                .plaidLink(
                    isPresented: $showPlaid,
                    token: linkToken ?? "",
                    onSuccess: { success in
                        print("✅ Success: public_token = \(success.publicToken)")
                        exchangePublicToken(success.publicToken) { success in
                            if success {
                                print("✅ Successfully exchanged public token")
                                onFinish()
                            }
                        }
                    },
                    onExit: { exit in
                        print("ℹ️ Exit: \(String(describing: exit.error?.errorMessage))")
                    },
                    onEvent: { event in
                        print("📡 Event: \(event.eventName)")
                    },
                    onLoad: {
                        print("🚀 Link UI loaded")
                    },
                    errorView: AnyView(Text("Plaid failed to load"))
                )
            }
        }
        .padding()
    }
}


