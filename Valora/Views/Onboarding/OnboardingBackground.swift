import SwiftUI

// MARK: - Onboarding Background (vibrant, animated)

struct OnboardingBackground: View {
    @State private var animate = false

    var body: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                .init(0.0, 0.0), .init(0.5, 0.0), .init(1.0, 0.0),
                .init(0.0, 0.5),
                .init(animate ? 0.62 : 0.38, animate ? 0.32 : 0.68),
                .init(1.0, 0.5),
                .init(0.0, 1.0), .init(0.5, 1.0), .init(1.0, 1.0)
            ],
            colors: [
                .mint.opacity(0.55), .teal.opacity(0.35), .cyan.opacity(0.45),
                .green.opacity(0.30), Color(.brandGreen).opacity(0.65), .mint.opacity(0.40),
                .teal.opacity(0.45), Color(.brandGreenLight).opacity(0.55), .green.opacity(0.35)
            ]
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - App Background (subtle, static — for main screens)

struct AppBackground: View {
    var body: some View {
        MeshGradient(
            width: 3, height: 3,
            points: [
                .init(0.0, 0.0), .init(0.5, 0.0), .init(1.0, 0.0),
                .init(0.0, 0.5), .init(0.5, 0.5), .init(1.0, 0.5),
                .init(0.0, 1.0), .init(0.5, 1.0), .init(1.0, 1.0)
            ],
            colors: [
                .mint.opacity(0.12), .teal.opacity(0.08), .cyan.opacity(0.10),
                .green.opacity(0.06), Color(.brandGreen).opacity(0.15), .mint.opacity(0.08),
                .teal.opacity(0.10), Color(.brandGreenLight).opacity(0.12), .green.opacity(0.07)
            ]
        )
        .ignoresSafeArea()
    }
}

// MARK: - Step Indicator (onboarding only)

struct OnboardingStepIndicator: View {
    let currentStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(
                        index < currentStep
                            ? AnyShapeStyle(ValoraColors.accent)
                            : AnyShapeStyle(.primary.opacity(0.15))
                    )
                    .frame(width: index == currentStep - 1 ? 28 : 8, height: 8)
            }
        }
        .animation(.spring(duration: 0.3), value: currentStep)
    }
}
