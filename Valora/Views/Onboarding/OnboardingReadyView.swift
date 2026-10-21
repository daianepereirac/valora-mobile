import SwiftUI

struct OnboardingReadyView: View {
    let storagesSummary: String
    let frequency: ShoppingFrequency
    let notificationsEnabled: Bool
    let onComplete: () -> Void

    @State private var appeared = false
    @State private var checkBounce = false

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: ValoraSpacing.xl) {
                // Step indicator (completed)
                OnboardingStepIndicator(currentStep: 4, totalSteps: 4)
                    .padding(.top, ValoraSpacing.lg)

                Spacer()

                // Checkmark icon
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ValoraColors.accent, .mint, .teal],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: checkBounce)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.5)

                // Title
                VStack(spacing: ValoraSpacing.sm) {
                    Text(String(localized: "onboarding.ready.title", defaultValue: "You're all set!"))
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.ready.subtitle", defaultValue: "Valora is personalized and ready for you"))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(appeared ? 1 : 0)
                .padding(.horizontal, ValoraSpacing.lg)

                Spacer()

                // Summary card
                VStack(alignment: .leading, spacing: ValoraSpacing.md) {
                    summaryRow(
                        icon: "refrigerator.fill",
                        label: String(localized: "onboarding.ready.storage", defaultValue: "Storage"),
                        value: storagesSummary
                    )
                    Divider().opacity(0.3)
                    summaryRow(
                        icon: "cart.fill",
                        label: String(localized: "onboarding.ready.shopping", defaultValue: "Shopping"),
                        value: frequency.displayName
                    )
                    Divider().opacity(0.3)
                    summaryRow(
                        icon: notificationsEnabled ? "bell.badge.fill" : "bell.slash.fill",
                        label: String(localized: "onboarding.ready.notifications", defaultValue: "Notifications"),
                        value: notificationsEnabled
                            ? String(localized: "onboarding.ready.notificationsOn", defaultValue: "Enabled")
                            : String(localized: "onboarding.ready.notificationsOff", defaultValue: "Disabled")
                    )
                }
                .padding(ValoraSpacing.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .padding(.horizontal, ValoraSpacing.xxl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.spring(duration: 0.6).delay(0.3), value: appeared)

                Spacer()

                // Start button
                PrimaryButton(
                    title: String(localized: "onboarding.ready.start", defaultValue: "Start Using Valora"),
                    action: onComplete
                )
                .padding(.horizontal, ValoraSpacing.xxl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 30)
                .animation(.spring(duration: 0.7).delay(0.5), value: appeared)
            }
            .padding(.vertical, ValoraSpacing.lg)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                checkBounce = true
            }
        }
    }

    @ViewBuilder
    private func summaryRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: ValoraSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(ValoraColors.accent)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body.weight(.medium))
            }
        }
    }
}
