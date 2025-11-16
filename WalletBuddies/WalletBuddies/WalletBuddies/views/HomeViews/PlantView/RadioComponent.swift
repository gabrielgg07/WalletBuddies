//
//  RadioComponenet.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/15/25.
//

import SwiftUI

struct RadioComponent: View {
    var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // RADIO BODY
            RoundedRectangle(cornerRadius: 14 * scale)
                .fill(Color(red: 0.85, green: 0.70, blue: 0.55))   // warm tan
                .frame(width: 180 * scale, height: 110 * scale)
                .overlay(
                    RoundedRectangle(cornerRadius: 14 * scale)
                        .stroke(Color.black.opacity(0.25), lineWidth: 2 * scale)
                )

            // SPEAKER GRILL
            RoundedRectangle(cornerRadius: 10 * scale)
                .fill(Color(red: 0.30, green: 0.30, blue: 0.40))   // dark gray-blue
                .frame(width: 85 * scale, height: 65 * scale)
                .offset(x: -35 * scale)

            // Grill lines
            VStack(spacing: 6 * scale) {
                ForEach(0..<5) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.35))
                        .frame(width: 70 * scale, height: 4 * scale)
                }
            }
            .offset(x: -35 * scale)

            // TUNING WINDOW
            RoundedRectangle(cornerRadius: 6 * scale)
                .fill(Color.white.opacity(0.85))
                .frame(width: 70 * scale, height: 25 * scale)
                .overlay(
                    Rectangle()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: 3 * scale, height: 25 * scale)
                )
                .offset(x: 45 * scale, y: -15 * scale)

            // KNOB
            Circle()
                .fill(Color(red: 0.65, green: 0.50, blue: 0.40))
                .frame(width: 28 * scale, height: 28 * scale)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.25), lineWidth: 2 * scale)
                )
                .offset(x: 50 * scale, y: 25 * scale)
        }
    }
}

struct RadioComponent_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemBackground)
            RadioComponent(scale: 1.2)
        }
    }
}
