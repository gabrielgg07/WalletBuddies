import SwiftUI

struct PlantTabView: View {
    @State private var showEducation: Bool = false
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            // Background gradient
            
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.20, blue: 0.55),
                    Color(red: 0.10, green: 0.10, blue: 0.25)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
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
            .offset(x: -10, y: -400)

            Rectangle()
                .fill(.gray.opacity(0.5))
                .frame(height: 200)
                .padding(.vertical, 60)
                .offset(y: 380)
            

            ZStack {
                //Color.white.ignoresSafeArea() // background


                        // Main bookshelf body
                    Rectangle()
                        .fill(Color(red: 0.35, green: 0.22, blue: 0.10)) // dark oak brown
                        .padding(.horizontal, 40)
                        .padding(.vertical, 60)
                        .shadow(radius: 4)


                Circle()
                    .trim(from: 0, to: 0.5)
                    .fill(.black)   // your dark blue// half
                    .rotationEffect(.degrees(180))     // round part DOWN
                    .frame(maxWidth: .infinity + 400)
                    .offset(y: 540)
                Circle()
                    .trim(from: 0, to: 0.5)
                    .fill(.orange)  // your dark blue// half
                    .rotationEffect(.degrees(180))     // round part DOWN
                    .frame(maxWidth: .infinity )
                    .offset(y: 560)
                VStack(spacing: 0) {
                        Spacer()


                    ForEach(0..<3) { _ in
                        Rectangle()
                        .fill(Color(red: 0.20, green: 0.12, blue: 0.05)) // darker wood for shelves
                        .frame(height: 8) // shelf thickness
                        .padding(.horizontal, 40)
                        Spacer()
                    }
                }
            }
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.20, green: 0.12, blue: 0.05), lineWidth: 8)   // 🔥 TRUE outer border
                    .padding(.horizontal, 40)
                    .padding(.vertical, 60)
            )
            

            VStack(spacing: -10) {  // adjust distance between lamp and cone
                LightFixture()
                
                ConeSpotlight()
                    .offset(y: 2)

                Spacer()
            }

            // Spotlight
            VStack {
                ConeSpotlight()
                    .offset(y: 2)   // move however you want

                Spacer()
            }
            
            PlantComponent(scale: 0.7)
                .offset(x: -80, y: -67)
            FlatBookStack()
                .offset(x: 80, y: 132)
                .onTapGesture {
                    showEducation = true;
                }
            FlatBookStack2(scale: 0.7)
                .offset(x: -150, y: -80)
                .rotationEffect(.degrees(270))
                .onTapGesture {
                    showEducation = true
                }
            ZStack {
                
                BonsaiPlant(scale: 0.8)
                    .offset(x: 80, y: -3)
            }
            
            RadioComponent(scale: 0.6)
                .offset(x: -60, y: -234)
                .onTapGesture {
                    AudioManager.shared.toggle(name: "audio1")
                }
            
  

        }
        .fullScreenCover(isPresented: $showEducation) {
            FinancialEducationView()
        }
    }
}

#Preview {
    PlantTabView()
        .preferredColorScheme(.dark)
}

struct ConeSpotlight: View {
    @State private var pulse = false

    var body: some View {
        ConicalShape()
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(pulse ? 0.65 : 0.25),   // 🔥 pulsates
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 220, height: 420)
            .blur(radius: pulse ? 28 : 15)                 // 🔥 glow pulses
            .animation(
                .easeInOut(duration: 2.4).repeatForever(autoreverses: true),
                value: pulse
            )
            .onAppear {
                pulse = true
            }
    }
}


struct ConicalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topWidth: CGFloat = rect.width * 0.35     // narrow top
        let bottomWidth: CGFloat = rect.width         // wide bottom

        let topX = (rect.width - topWidth) / 2
        let bottomX = (rect.width - bottomWidth) / 2

        path.move(to: CGPoint(x: topX, y: 0))
        path.addLine(to: CGPoint(x: topX + topWidth, y: 0))
        path.addLine(to: CGPoint(x: bottomX + bottomWidth, y: rect.height))
        path.addLine(to: CGPoint(x: bottomX, y: rect.height))
        path.closeSubpath()

        return path
    }
}

struct LightFixture: View {
    var body: some View {
        VStack(spacing: 0) {

            // Top bar (light mount)
            Rectangle()
                .fill(Color.gray.opacity(0.6))
                .frame(width: 120, height: 6)

            // Dome shape
            Circle()
                .trim(from: 0, to: 0.5)
                .fill(Color.gray.opacity(0.8))
                .frame(width: 100, height: 80)
                .offset(y: -40)// half circle
                //.rotationEffect(.degrees(180))          // round part D
                
        }
    }
}

