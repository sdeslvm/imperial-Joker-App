import SwiftUI

extension View {
    func imperialProgressBar(_ value: Double) -> some View {
        modifier(ImperialProgressModifier(progress: value))
    }
}

struct ImperialProgressModifier: ViewModifier {
    let progress: Double

    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                    .ignoresSafeArea()
                ImperialProgressOverlay(progress: progress)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(
                ZStack {
                    Image(.tileWater500X500)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                }
                    .frame(width: geo.size.width, height: geo.size.height)
            )
        }
    }
}

struct ImperialProgressOverlay: View {
    let progress: Double
    @State private var crownRotation: Double = 0

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                // Вращающаяся корона (или другой символ)
                Image(systemName: "crown.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90, height: 90)
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(crownRotation))
                    .shadow(color: .green.opacity(0.7), radius: 10, x: 0, y: 0)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            crownRotation = 360
                        }
                    }
            }
            .frame(height: 120)
            Spacer()
            Text("Loading")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            // Анимированная волна-прогрессбар
            WaveProgressBar(progress: progress)
                .frame(height: 40)
                .padding(.horizontal, 40)
            Text("\(Int(progress * 100))%")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .padding(.top, 10)
            Spacer()
        }
    }
}

// Анимированная волна-прогрессбар
struct WaveProgressBar: View {
    let progress: Double
    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Волна
                WaveShape(progress: progress, phase: phase)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.green.opacity(0.7), .mint.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .animation(.easeInOut(duration: 0.4), value: progress)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = .pi * 2
                        }
                    }
                // Контур
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct WaveShape: Shape {
    var progress: Double
    var phase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let waveHeight: CGFloat = 10
        let yOffset = rect.height * CGFloat(1 - progress)
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: yOffset))
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * 2 * .pi + phase)
            let y = yOffset + sine * waveHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.closeSubpath()
        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}

// Плавающие пузырьки
struct BubbleAnimationView: View {
    let progress: Double
    @State private var animate = false

    var body: some View {
        ZStack {
            ForEach(0..<7, id: \.self) { i in
                BubbleView(
                    xOffset: CGFloat(i) * 22 + CGFloat.random(in: -8...8),
                    delay: Double(i) * 0.3,
                    progress: progress
                )
            }
        }
        .frame(width: 120, height: 100)
    }
}

struct BubbleView: View {
    let xOffset: CGFloat
    let delay: Double
    let progress: Double
    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 0.7

    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: CGFloat.random(in: 10...18), height: CGFloat.random(in: 10...18))
            .offset(x: xOffset, y: yOffset)
            .onAppear {
                let base = CGFloat(60 + Double(progress) * 20)
                withAnimation(Animation.easeInOut(duration: 2.5).repeatForever().delay(delay)) {
                    yOffset = -base
                    opacity = 0.2
                }
            }
    }
}

#Preview {
    Text("Preview").imperialProgressBar(0.2)
}
