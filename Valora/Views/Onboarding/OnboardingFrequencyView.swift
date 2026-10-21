import SwiftUI

struct OnboardingFrequencyView: View {
    @Binding var selectedFrequency: ShoppingFrequency
    let onNext: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false
    @State private var iconWiggle = false

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: ValoraSpacing.xl) {
                // Navigation + Step
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.body.bold())
                            .padding(ValoraSpacing.sm)
                            .glassEffect(.regular.interactive(), in: .circle)
                    }
                    Spacer()
                    OnboardingStepIndicator(currentStep: 2, totalSteps: 4)
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, ValoraSpacing.lg)

                // Cart icon
                Image(systemName: "cart.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ValoraColors.accent, .teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.wiggle, value: iconWiggle)
                    .opacity(appeared ? 1 : 0)

                // Title
                VStack(spacing: ValoraSpacing.sm) {
                    Text(String(localized: "onboarding.frequency.title", defaultValue: "How often do you shop?"))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.frequency.subtitle", defaultValue: "We'll remind you on shopping days"))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, ValoraSpacing.lg)
                .opacity(appeared ? 1 : 0)

                // Frequency cards
                GlassEffectContainer {
                    VStack(spacing: ValoraSpacing.sm) {
                        ForEach(Array(ShoppingFrequency.allCases.enumerated()), id: \.element.id) { index, frequency in
                            frequencyCard(frequency, index: index)
                        }
                    }
                }
                .padding(.horizontal, ValoraSpacing.xxl)

                Spacer()

                // Continue
                PrimaryButton(
                    title: String(localized: "onboarding.frequency.next", defaultValue: "Continue"),
                    action: onNext
                )
                .padding(.horizontal, ValoraSpacing.xxl)
            }
            .padding(.vertical, ValoraSpacing.lg)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(duration: 0.6)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                iconWiggle = true
            }
        }
    }

    @ViewBuilder
    private func frequencyCard(_ frequency: ShoppingFrequency, index: Int) -> some View {
        let isSelected = selectedFrequency == frequency

        Button {
            withAnimation(.spring(duration: 0.3)) {
                selectedFrequency = frequency
            }
        } label: {
            HStack {
                Text(frequency.displayName)
                    .font(.body.weight(isSelected ? .semibold : .regular))
                    .foregroundStyle(.primary)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(ValoraColors.accent)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(ValoraSpacing.lg)
            .glassEffect(
                isSelected
                    ? .regular.tint(ValoraColors.accent.opacity(0.15))
                    : .regular,
                in: .rect(cornerRadius: 14)
            )
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
        .animation(
            .spring(duration: 0.5).delay(Double(index) * 0.08),
            value: appeared
        )
    }
}
