//
//  QuickActionViews.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/3/25.
//

import SwiftUI

// MARK: - Base template for consistent look
struct QuickActionTemplate<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.mint.opacity(0.25), .white],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text(title)
                        .font(.title2.bold())
                    Spacer()
                    Image(systemName: icon)
                        .foregroundColor(.accentColor)
                        .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Content Card
                VStack(spacing: 20) {
                    content
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

// MARK: - Add Expense
struct AddExpenseView: View {
    @State private var name = ""
    @State private var amount = ""
    @State private var category = "Food"
    
    var body: some View {
        QuickActionTemplate(title: "Add Expense", icon: "plus.circle.fill") {
            TextField("Expense name", text: $name)
                .textFieldStyle(.roundedBorder)
            TextField("Amount ($)", text: $amount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            Picker("Category", selection: $category) {
                ForEach(["Food", "Travel", "Bills", "Entertainment"], id: \.self) { cat in
                    Text(cat)
                }
            }
            .pickerStyle(.menu)
            
            Button("Save Expense") {}
                .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Reports
struct ReportsView: View {
    var body: some View {
        QuickActionTemplate(title: "Reports", icon: "chart.bar.fill") {
            VStack(spacing: 12) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.mint)
                Text("Monthly Spending Overview")
                    .font(.headline)
                Text("Coming soon: graphs & trends for your expenses.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Goals
struct GoalsView: View {
    @State private var goalName = ""
    @State private var goalAmount = ""
    
    var body: some View {
        QuickActionTemplate(title: "Goals", icon: "target") {
            TextField("Goal name (e.g. Vacation Fund)", text: $goalName)
                .textFieldStyle(.roundedBorder)
            TextField("Target amount ($)", text: $goalAmount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            Button("Create Goal") {}
                .buttonStyle(.borderedProminent)
                .tint(.mint)
        }
    }
}

#Preview {
    AddExpenseView()
}
