//
//  FinancialEducation.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/15/25.
//

import SwiftUI

import SwiftUI

struct FinancialEducationView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {

            // BACKGROUND GRADIENT (your exact colors)
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.20, blue: 0.55),
                    Color(red: 0.10, green: 0.10, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    headerCard

                    FinancialSectionCard(
                        title: "What Is Personal Finance?",
                        subtitle: "Understanding the building blocks.",
                        details: """
Personal finance covers:
• Budgeting  
• Saving  
• Investing  
• Debt management  
• Financial planning  

Learning these principles sets the foundation for lifelong stability.
"""
                    )

                    FinancialSectionCard(
                        title: "Budgeting Frameworks",
                        subtitle: "The proven 50/30/20 approach.",
                        details: """
The 50/30/20 rule helps keep money organized:
• 50% Needs  
• 30% Wants  
• 20% Savings / Debt payoff  

Budgeting isn't restriction — it's clarity.
"""
                    )

                    FinancialSectionCard(
                        title: "Beginner Investing",
                        subtitle: "Principles that never change.",
                        details: """
Investing works best when:
• You invest consistently  
• You diversify  
• You avoid high fees  
• You understand risk  
• You stay invested long-term  

Index funds are widely recommended for beginners.
"""
                    )

                    FinancialSectionCard(
                        title: "How Credit Scores Work",
                        subtitle: "The 5 factors behind FICO.",
                        details: """
Your credit score depends on:
• Payment history (35%)  
• Credit usage (30%)  
• Account age (15%)  
• Credit mix (10%)  
• New credit (10%)

Tip: Keep card utilization under 30%.
"""
                    )

                    progressVisualization
                        .padding(.bottom, 50)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }

            // BACK BUTTON OVERLAY
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                            Text("Back")
                                .font(.headline)
                        }
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.25))
                        .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()
            }
            .offset(y: -40)
        }
    }
}







// MARK: - HEADER CARD
private var headerCard: some View {
    VStack(alignment: .leading, spacing: 16) {
        Text("Money Smart 101")
            .font(.largeTitle.bold())
            .foregroundColor(.white)

        Text("Clear, friendly lessons to help you master money, one step at a time.")
            .foregroundColor(.white.opacity(0.85))
            .font(.body)

        Image(systemName: "chart.pie.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 110)
            .foregroundColor(.white.opacity(0.9))
            .padding(.top, 4)
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.white.opacity(0.12))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    )
}






// MARK: - SECTION CARD COMPONENT
struct FinancialSectionCard: View {
    var title: String
    var subtitle: String
    var details: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.75))

            Divider().background(Color.white.opacity(0.3))

            Text(details)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}





// MARK: - PROGRESS VISUALIZATION
private var progressVisualization: some View {
    VStack(spacing: 20) {
        Text("Your Financial Building Blocks")
            .font(.headline)
            .foregroundColor(.white.opacity(0.9))

        HStack(spacing: 24) {
            ProgressBubble(label: "Budgeting", value: 0.8, color: .green)
            ProgressBubble(label: "Saving", value: 0.5, color: .blue)
            ProgressBubble(label: "Investing", value: 0.3, color: .purple)
        }
    }
}

struct ProgressBubble: View {
    var label: String
    var value: CGFloat
    var color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 8)
                    .frame(width: 70, height: 70)

                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color.opacity(0.9),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 70, height: 70)

                Text("\(Int(value * 100))%")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }

            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
    }
}





// MARK: - PREVIEW
struct FinancialEducationView_Previews: PreviewProvider {
    static var previews: some View {
        FinancialEducationView()
    }
}
