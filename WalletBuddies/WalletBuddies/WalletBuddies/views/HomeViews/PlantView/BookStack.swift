//
//  BookStack.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/15/25.
//

import SwiftUI

// MARK: - Book Stack (3–5 books recommended)
struct FlatBookStack: View {
    var scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing:0) {
            FlatBook(color: Color(red: 0.55, green: 0.50, blue: 0.80), scale: scale, height: 140)
                .offset(y: -10)
            FlatBook(color: Color(red: 0.65, green: 0.40, blue: 0.70), scale: scale, height: 100)
                .offset(y: 10)
            FlatBook(color: Color(red: 0.80, green: 0.65, blue: 0.85), scale: scale, height: 120)
            FlatBook(color: Color(red: 0.70, green: 0.85, blue: 0.70), scale: scale, height: 150)
                .offset(y: -15)

        }
    }
}
struct FlatBookStack2: View {
    var scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 0) {
            FlatBook(color: Color(red: 0.80, green: 0.90, blue: 0.65), scale: scale, height: 150)
                .offset(y: 0)
            
            FlatBook(color: Color(red: 0.60, green: 0.70, blue: 0.95), scale: scale, height: 140)
                .offset(y: 5)
            
            FlatBook(color: Color(red: 0.95, green: 0.75, blue: 0.85), scale: scale, height: 120)
                .offset(y: 15)
            
            FlatBook(color: Color(red: 0.85, green: 0.85, blue: 0.45), scale: scale, height: 100)
                .offset(y: 25)
        }
    }
}


// MARK: - Single Flat Book
struct FlatBook: View {
    var color: Color
    var scale: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4 * scale)
                .fill(color.opacity(1))
                .frame(width: 30 * scale, height: height * scale)
                .overlay(
                    VStack {
                        // Upper stripe
                        Rectangle()
                            .fill(Color.black.opacity(0.20).blendMode(.multiply))
                            .frame(height: 10 * scale)
                            //.padding(.top, 8 * scale)
                        
  
                        // Upper stripe
                        Rectangle()
                            .fill(Color.black.opacity(0.15).blendMode(.multiply))
                            .frame(height: 12 * scale)
                            .padding(.top, 8 * scale)
                        
                        Spacer()
                        
                        // Lower stripe
                        Rectangle()
                            .fill(Color.black.opacity(0.15).blendMode(.multiply))
                            .frame(height: 10 * scale)
                            .padding(.bottom, 8 * scale)
             
                        // Lower stripe
                        Rectangle()
                            .fill(Color.black.opacity(0.15).blendMode(.multiply))
                            .frame(height: 10 * scale)
                            //.padding(.bottom, 8 * scale)
                    }
                )
        }
    }
}

extension Color {
    func darken(by amount: Double) -> Color {
        // amount: 0.0 → no change, 0.4 → 40% darker
        return self.opacity(1.0 - amount)
    }
}


#Preview {
    ZStack {
        Color(red: 0.08, green: 0.12, blue: 0.35)
            .ignoresSafeArea()
        
        FlatBookStack2(scale: 1.0)
    }
}
