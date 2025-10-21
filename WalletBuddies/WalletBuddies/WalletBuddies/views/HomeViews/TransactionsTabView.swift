//
//  TransactionsTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/24/25.
//


import SwiftUI

struct TransactionsTabView: View {
    @State private var selectedTab = 0
    @State private var transactions: [Transaction] = []
    @State private var isLoading = true
    
    @EnvironmentObject var auth: AuthManager
    var body: some View {
        VStack(alignment: .leading) {
            Picker("Accounts", selection: $selectedTab) {
                Text("Checking").tag(0)
                Text("Savings").tag(1)
                Text("Credit").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            
            if isLoading {
                ProgressView("Loading transactions…")
                    .padding()
            } else if transactions.isEmpty {
                Text("No transactions found :(")
                    .font(.title3)
                    .padding()
            } else {
                TransactionList(items: transactions)
            }
        }
        .onAppear {
            // Fetch from backend
            fetchTransactions(auth: auth) { txns in
                self.transactions = txns
                self.isLoading = false
            }
        }
    }
}

struct TransactionList: View {
    let items: [Transaction]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(items) { txn in
                    HStack {
                        Text(txn.name ?? "Unknown")
                        Spacer()
                        Text(String(format: "$%.2f", txn.amount ?? 0))
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
