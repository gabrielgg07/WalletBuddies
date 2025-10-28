//
//  BudgetBucketsView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 10/26/25.
//

import SwiftUI

struct BudgetBucketsView: View {
    @State private var buckets: [BudgetBucket] = [
        .init(category: "Food", goal: 400, color: .green),
        .init(category: "Rent", goal: 1200, color: .blue),
        .init(category: "Travel", goal: 600, color: .orange),
        .init(category: "Entertainment", goal: 250, color: .pink)
    ]
    
    @State private var selectedBucket: BudgetBucket? = nil
    @State private var showingCreateView: Bool = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(buckets) { bucket in
                        VStack(spacing: 8) {
                            Circle()
                                .fill(bucket.color)
                                .frame(width: 80, height: 80)
                                .shadow(radius: 3)
                                .onTapGesture {
                                    selectedBucket = bucket
                                    showingCreateView = true
                                }
                            
                            Text(bucket.category)
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            Text("$\(Int(bucket.goal)) goal")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Add New Bucket button
                Button(action: {
                    selectedBucket = nil
                    showingCreateView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Bucket")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing)
                    )
                    .cornerRadius(14)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 60)
            }
            .background(Color.gray.opacity(0.05).ignoresSafeArea())
            .navigationTitle("Your Buckets")
            .navigationBarTitleDisplayMode(.large)
            
            // Full-screen modal for create/edit
            .fullScreenCover(isPresented: $showingCreateView) {
                CreateBudgetBucketView()
            }
        }
    }
}

#Preview {
    BudgetBucketsView()
}
