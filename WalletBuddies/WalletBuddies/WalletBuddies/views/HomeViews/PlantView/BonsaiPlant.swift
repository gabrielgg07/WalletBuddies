import SwiftUI

import SwiftUI

struct BonsaiPlant: View {
    var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            BonsaiTrunk(scale: scale)
                .offset(x: 100)
            BonsaiTrunk2(scale: scale)
                .offset(x: 80)
                
            BonsaiLeaves(scale: scale)
                .offset(y: -80)
  
            BonsaiPot(scale: scale)
                .offset(x: 0, y: -20)
        }
        .frame(width: 220 * scale, height: 200 * scale)
    }
}








// MARK: - POT (simple + flat)
struct BonsaiPot: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8 * scale)
                .fill(Color(red: 0.72, green: 0.50, blue: 0.68))   // pinkish-purple
                .frame(width: 120 * scale, height: 45 * scale)

            Rectangle()
                .fill(Color(red: 0.60, green: 0.40, blue: 0.58))
                .frame(width: 135 * scale, height: 14 * scale)
                .offset(y: -24 * scale)
        }
    }
}







// MARK: - TRUNK (simple wiggly path)
struct BonsaiTrunk: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            // Main trunk path
            Path { path in
                path.move(to: CGPoint(x: 0, y: 60 * scale))

                // base curve
                path.addCurve(
                    to: CGPoint(x: 10 * scale, y: 10 * scale),
                    control1: CGPoint(x: -20 * scale, y: 40 * scale),
                    control2: CGPoint(x: 5 * scale, y: 30 * scale)
                )

                // split into two branches
                path.addCurve(
                    to: CGPoint(x: -5 * scale, y: -20 * scale),
                    control1: CGPoint(x: 40 * scale, y: -5 * scale),
                    control2: CGPoint(x: 10 * scale, y: -15 * scale)
                )
            }
            .stroke(
                Color(red: 0.22, green: 0.20, blue: 0.25),
                style: StrokeStyle(lineWidth: 18 * scale, lineCap: .round)
            )

            // Right branch
            Path { path in
                path.move(to: CGPoint(x: 10 * scale, y: 10 * scale))
                path.addCurve(
                    to: CGPoint(x: 40 * scale, y: -5 * scale),
                    control1: CGPoint(x: 25 * scale, y: 0),
                    control2: CGPoint(x: 35 * scale, y: -2 * scale)
                )
            }
            .stroke(
                Color(red: 0.22, green: 0.20, blue: 0.25),
                style: StrokeStyle(lineWidth: 10 * scale, lineCap: .round)
            )
        }
    }
}

struct BonsaiTrunk2: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            // MAIN TRUNK
            Path { path in
                path.move(to: CGPoint(x: 0, y: 60 * scale))

                // first bend
                path.addCurve(
                    to: CGPoint(x: -8 * scale, y: 20 * scale),
                    control1: CGPoint(x: -25 * scale, y: 45 * scale),
                    control2: CGPoint(x: -20 * scale, y: 30 * scale)
                )

                // mid curve
                path.addCurve(
                    to: CGPoint(x: 12 * scale, y: -5 * scale),
                    control1: CGPoint(x: 10 * scale, y: 10 * scale),
                    control2: CGPoint(x: 20 * scale, y: 0)
                )

                // top flare
                path.addCurve(
                    to: CGPoint(x: -6 * scale, y: -35 * scale),
                    control1: CGPoint(x: 5 * scale, y: -15 * scale),
                    control2: CGPoint(x: -5 * scale, y: -25 * scale)
                )
            }
            .stroke(
                Color(red: 0.22, green: 0.20, blue: 0.25),
                style: StrokeStyle(lineWidth: 18 * scale, lineCap: .round)
            )

            // RIGHT BRANCH (new shape)
            Path { path in
                path.move(to: CGPoint(x: 8 * scale, y: 5 * scale))

                path.addCurve(
                    to: CGPoint(x: 35 * scale, y: -10 * scale),
                    control1: CGPoint(x: 20 * scale, y: 0),
                    control2: CGPoint(x: 30 * scale, y: -5 * scale)
                )
            }
            .stroke(
                Color(red: 0.22, green: 0.20, blue: 0.25),
                style: StrokeStyle(lineWidth: 10 * scale, lineCap: .round)
            )

            // MINI LEFT BRANCH (subtle)
            Path { path in
                path.move(to: CGPoint(x: -8 * scale, y: 18 * scale))

                path.addCurve(
                    to: CGPoint(x: -28 * scale, y: 5 * scale),
                    control1: CGPoint(x: -18 * scale, y: 15 * scale),
                    control2: CGPoint(x: -25 * scale, y: 10 * scale)
                )
            }
            .stroke(
                Color(red: 0.22, green: 0.20, blue: 0.25),
                style: StrokeStyle(lineWidth: 8 * scale, lineCap: .round)
            )
        }
    }
}


// MARK: - LEAF BLOBS (simple ovals)
struct LeafBlob: View {
    var width: CGFloat
    var height: CGFloat
    var scale: CGFloat
    var color: Color

    var body: some View {
        Ellipse()
            .fill(color)
            .frame(width: width * scale, height: height * scale)
    }
}








// MARK: - LEAF CLUSTER
struct BonsaiLeaves: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            // back layer leaves (darker mint)
            LeafBlob(width: 120, height: 55, scale: scale, color: Color(red: 0.7, green: 0.9, blue: 0.78))
                .offset(y: -55 * scale)
            

            HorizontalCluster(scale: scale)
                .offset(y: -25 * scale)

            // front top leaf (lightest tone)
            LeafBlob(width: 95, height: 45, scale: scale, color: Color(red: 0.78, green: 0.92, blue: 0.82))
                .offset(y: -70 * scale)
        }
    }
}

// Left + Right leaf blobs
struct HorizontalCluster: View {
    var scale: CGFloat

    var body: some View {
        ZStack {
            LeafBlob(width: 85, height: 40, scale: scale, color: Color(red: 0.70, green: 0.90, blue: 0.78))
                .offset(x: -55 * scale, y: 10)
            LeafBlob(width: 85, height: 40, scale: 0.8, color: Color(red: 0.70, green: 0.90, blue: 0.78))
                .offset(x: -30, y: -10)
            LeafBlob(width: 80, height: 38, scale: scale, color: Color(red: 0.70, green: 0.90, blue: 0.78))
                .offset(x: 55 * scale)
        }
    }
}









// MARK: - PREVIEW
struct BonsaiPlant_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.opacity(0.2).ignoresSafeArea()
            BonsaiPlant(scale: 0.8)
        }
        .preferredColorScheme(.dark)
    }
}

