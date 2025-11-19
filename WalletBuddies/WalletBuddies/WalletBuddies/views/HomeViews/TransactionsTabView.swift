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
    @State private var isLoading: Bool = true
    
    @State private var showBuckets = false
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
            Button(action: {
                showBuckets = true
            }) {
                Text("Create Budgeting Buckets")
            }
            
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
        .fullScreenCover(isPresented: $showBuckets){
            BudgetBucketsView()
        }
        .onAppear {
            // Fetch from backend
            refreshTransactions(auth: auth) { txns in
                self.transactions = txns
                self.isLoading = false
            }
            fetchNetValue(auth: auth) { net in
                print("🔥 User net spending:", net)
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

