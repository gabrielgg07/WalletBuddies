//
//  HomeTabView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 9/23/25.
//

import SwiftUI

struct HomeTabView: View {
    @State private var balance: Double = 2540.75
    @State private var monthlySpending: Double = 892.30
    @State private var savingsGoal: Double = 5000.00
    @EnvironmentObject var auth: AuthManager

    @State private var showAddExpense = false
    @State private var showReports = false
    @State private var showGoals = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {

                    // MARK: - Welcome Header
                    VStack(alignment: .leading, spacing: 6) {

                        Text("Good Afternoon, " + auth.name + " 👋")

                            .font(.title2.bold())
                        Text("Here’s your financial snapshot:")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    // MARK: - Balance Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Balance")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("$\(balance, specifier: "%.2f")")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        ProgressView(value: monthlySpending, total: savingsGoal) {
                            Text("Monthly Spending")
                                .font(.caption)
                        }
                        .tint(.green)
                        .padding(.top, 8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [.mint.opacity(0.25), .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
                    )
                    .padding(.horizontal)

                    // MARK: - Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 18) {
                            quickAction(icon: "plus.circle.fill", title: "Add Expense")
                            quickAction(icon: "chart.bar.fill", title: "View Reports")
                            quickAction(icon: "target", title: "Goals")
                        }
                        .padding(.horizontal)
                    }

                    // MARK: - Financial News Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Financial News")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 14) {
                            newsCard(
                                title: "Markets Rally as Inflation Cools",
                                source: "Bloomberg",
                                image: "chart.line.uptrend.xyaxis",
                                url: "https://www.bloomberg.com/"
                            )
                            newsCard(
                                title: "How to Build an Emergency Fund",
                                source: "CNBC",
                                image: "banknote",
                                url: "https://www.cnbc.com/select/how-to-build-an-emergency-fund/"
                            )
                            newsCard(
                                title: "Top Budgeting Strategies for 2025",
                                source: "Forbes",
                                image: "wallet.pass",
                                url: "https://www.forbes.com/advisor/personal-finance/budgeting-strategies/"
                            )
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 50)
                }
                .padding(.top)
            }
            .navigationTitle("Home")
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(isPresented: $showAddExpense) { AddExpenseView() }
        .fullScreenCover(isPresented: $showReports) { ReportsView() }
        .fullScreenCover(isPresented: $showGoals) { GoalsView() }
    }

    // MARK: - Reusable Components
    private func quickAction(icon: String, title: String) -> some View {
        Button {
            switch title {
            case "Add Expense": showAddExpense = true
            case "View Reports": showReports = true
            case "Goals": showGoals = true
            default: break
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(LinearGradient(colors: [.mint, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }


    @Environment(\.openURL) private var openURL
    
    private func newsCard(title: String, source: String, image: String, url: String) -> some View {
        Button {
            if let link = URL(string: url) {
                openURL(link)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: image)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                    .foregroundColor(.mint)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.bold())
                        .lineLimit(2)
                    Text(source)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.15), radius: 3, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

