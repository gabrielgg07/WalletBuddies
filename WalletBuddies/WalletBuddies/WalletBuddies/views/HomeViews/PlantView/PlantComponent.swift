//
//  PlantComponent.swift
//  WalletBuddies
//
//  Created by Gabriel Gonzalez on 11/15/25.
//

import SwiftUI

// MARK: - Master Scalable Plant Component
struct PlantComponent: View {
    var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            PlantGlow(scale: scale)

            VStack(spacing: 0) {
                PlantLeaves(scale: scale)
                PlantStem(scale: scale)
                PlantPot(scale: scale)
            }
        }
        .scaleEffect(scale)
    }
}

// MARK: - Glow
struct PlantGlow: View {
    var scale: CGFloat

    var body: some View {
        Circle()
            .fill(Color.green.opacity(0.25))
            .blur(radius: 35 * scale)
            .frame(width: 160 * scale, height: 160 * scale)
            .offset(y: 20 * scale)
    }
}

// MARK: - Leaves Group
struct PlantLeaves: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            Leaf(scale: scale, angle: -28, xOffset: -40)
            Leaf(scale: scale, angle: 28, xOffset: 40)
            Leaf(scale: scale, angle: 0, xOffset: 0, isCenter: true)
        }
        .padding(.bottom, -12 * scale)
    }
}

// MARK: - Single Leaf Component
struct Leaf: View {
    var scale: CGFloat
    var angle: Double
    var xOffset: CGFloat
    var isCenter: Bool = false

    var body: some View {
        LeafShape()
            .fill(isCenter ? centerGradient : sideGradient)
            .frame(
                width: (isCenter ? 130 : 120) * scale,
                height: (isCenter ? 150 : 120) * scale
            )
            .rotationEffect(.degrees(angle))
            .offset(x: xOffset * scale, y: (isCenter ? -20 : -10) * scale)
            .shadow(color: .green.opacity(0.4), radius: 6 * scale)
    }

    private var centerGradient: LinearGradient {
        LinearGradient(
            colors: [Color.green.opacity(0.95), Color.green.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var sideGradient: LinearGradient {
        LinearGradient(
            colors: [Color.green, Color.green.opacity(0.45)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Stem
struct PlantStem: View {
    var scale: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 3 * scale)
            .fill(Color.green.opacity(0.8))
            .frame(width: 10 * scale, height: 40 * scale)
    }
}

// MARK: - Pot
struct PlantPot: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            // Pot body
            RoundedRectangle(cornerRadius: 6 * scale)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.65, green: 0.35, blue: 0.20),
                            Color(red: 0.45, green: 0.22, blue: 0.10)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 120 * scale, height: 80 * scale)
                

            // Pot rim
            Rectangle()
                .fill(Color(red: 0.4, green: 0.2, blue: 0.1))
                .frame(width: 130 * scale, height: 18 * scale)
                .offset(y: -40 * scale)
        }
    }
}

// MARK: - Leaf Shape
struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        return path
    }
}

#Preview {
    PlantComponent(scale: 1.0)
        .padding()
        .background(Color.white)
}
