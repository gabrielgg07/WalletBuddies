//
//  CreateBudgetBucketView.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 10/26/25.
//

import SwiftUI

struct BudgetBucket: Identifiable {
    let id = UUID()
    var category: String
    var goal: Double
    var color: Color
    var description: String?
}

struct CreateBudgetBucketView: View {
    
    @State private var selectedCategory: String? = nil
    @State private var goalAmount: String = ""
    @State private var selectedColor: Color = .green
    @State private var description: String = ""
    @State private var createdBuckets: [BudgetBucket] = []
    @State private var showConfirmation: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    private let categories: [String] = [
        "Food", "Rent", "Shopping", "Entertainment",
        "Travel", "Health", "Education", "Savings", "Miscellaneous"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Create Budget Bucket")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                    Spacer()
                    Spacer().frame(width: 36)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Category Picker
                        Text("Select Category")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { cat in
                                    CategoryChip(
                                        text: cat,
                                        isSelected: selectedCategory == cat
                                    ) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Goal Amount
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Goal Amount ($)")
                                .font(.headline)
                                .foregroundColor(.gray)
                            TextField("Enter amount", text: $goalAmount)
                                .keyboardType(.decimalPad)
                                .onChange(of: goalAmount) { newValue in
                                    // allow only digits and one decimal point
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    let decimalCount = filtered.filter { $0 == "." }.count
                                    if filtered != newValue || decimalCount > 1 {
                                        goalAmount = String(filtered.prefix { $0 != "." || decimalCount <= 1 })
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)

                        }
                        
                        // Color Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose Color")
                                .font(.headline)
                                .foregroundColor(.gray)
                            ColorSelectionRow(selectedColor: $selectedColor)
                                .padding(.horizontal)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description (optional)")
                                .font(.headline)
                                .foregroundColor(.gray)
                            TextField("Add details about this bucket", text: $description)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        // Save Button
                        Button(action: saveBucket) {
                            Text("Save Bucket")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    colors: [.green, .mint],
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .cornerRadius(14)
                                .shadow(radius: 4)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        if showConfirmation {
                            Text("✅ Bucket Added!")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                                .transition(.opacity)
                                .padding(.horizontal)
                        }
                        
                        // Preview Section
                        if !createdBuckets.isEmpty {
                            Text("Your Buckets")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                                .padding(.top, 10)
                            
                            ForEach(createdBuckets) { bucket in
                                BucketPreviewCard(bucket: bucket)
                                    .padding(.horizontal)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 10)
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
    
    private func saveBucket() {
        guard let category = selectedCategory,
              let goal = Double(goalAmount), goal > 0 else { return }
        
        let newBucket = BudgetBucket(
            category: category,
            goal: goal,
            color: selectedColor,
            description: description.isEmpty ? nil : description
        )
        createdBuckets.append(newBucket)
        goalAmount = ""
        description = ""
        selectedCategory = nil
        showConfirmation = true
        
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfirmation = false
            }
        }
    }
    

}

// MARK: - Subcomponents

struct CategoryChip: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Text(text)
            .font(.subheadline.bold())
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .green : .black)
            .cornerRadius(20)
            .onTapGesture { action() }
    }
}

struct ColorSelectionRow: View {
    @Binding var selectedColor: Color
    private let colors: [Color] = [.green, .blue, .orange, .pink, .purple, .yellow, .mint, .teal]
    
    var body: some View {
        HStack(spacing: 14) {
            ForEach(colors, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(selectedColor == color ? 0.6 : 0), lineWidth: 2)
                    )
                    .onTapGesture { selectedColor = color }
            }
        }
    }
}

struct BucketPreviewCard: View {
    var bucket: BudgetBucket
    
    var body: some View {
        HStack {
            Circle()
                .fill(bucket.color)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading) {
                Text(bucket.category)
                    .font(.headline)
                Text("$\(Int(bucket.goal)) Goal")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2)
    }
}

#Preview {
    CreateBudgetBucketView()
}
