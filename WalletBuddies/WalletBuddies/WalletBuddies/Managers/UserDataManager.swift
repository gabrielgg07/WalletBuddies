//
//  UserDataManager.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 10/28/25.
//

import SwiftUI

// MARK: - Model
struct BudgetBucket: Identifiable, Codable, Equatable {
    let id: UUID
    var category: String
    var goal: Double
    var colorHex: String
    var description: String?
    
    // Convert SwiftUI Color <-> Hex for saving
    var color: Color {
        get { Color(hex: colorHex) }
        set { colorHex = newValue.toHex() ?? "#00FF00" } // default green
    }
    
    init(category: String, goal: Double, color: Color, description: String? = nil) {
        self.id = UUID()
        self.category = category
        self.goal = goal
        self.colorHex = color.toHex() ?? "#00FF00"
        self.description = description
    }
}

// MARK: - Manager
@MainActor
class UserDataManager: ObservableObject {
    static let shared = UserDataManager()
    
    @Published var buckets: [BudgetBucket] = [] {
        didSet { saveBuckets() }
    }
    
    private let storageKey = "userBuckets"
    
    private init() {
        loadBuckets()
    }
    
    func addBucket(_ bucket: BudgetBucket) {
        buckets.append(bucket)
    }
    
    func deleteBucket(_ bucket: BudgetBucket) {
        buckets.removeAll { $0.id == bucket.id }
    }
    
    private func saveBuckets() {
        if let encoded = try? JSONEncoder().encode(buckets) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadBuckets() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([BudgetBucket].self, from: data) {
            buckets = decoded
        }
    }
}


import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 255, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }

    func toHex() -> String? {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }
}
