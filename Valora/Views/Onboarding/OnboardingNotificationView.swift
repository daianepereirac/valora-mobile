import SwiftUI

struct OnboardingNotificationView: View {
    let onRequestPermission: () -> Void
    let permissionGranted: Bool
    let onNext: () -> Void
    let onSkip: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var requested = false
    @State private var appeared = false
    @State private var bellBounce = false

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
                    OnboardingStepIndicator(currentStep: 3, totalSteps: 4)
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, ValoraSpacing.lg)

                Spacer()

                // Bell icon
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ValoraColors.accent, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: bellBounce)
                    .opacity(appeared ? 1 : 0)

                // Title
                VStack(spacing: ValoraSpacing.sm) {
                    Text(String(localized: "onboarding.notification.title", defaultValue: "Stay on top of freshness"))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.notification.subtitle", defaultValue: "Get notified when food is about to expire so you can use it in time"))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, ValoraSpacing.lg)
                .opacity(appeared ? 1 : 0)

                // Mock notification
                mockNotificationCard()
                    .padding(.horizontal, ValoraSpacing.xxl)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.spring(duration: 0.6).delay(0.3), value: appeared)

                Spacer()

                // Buttons
                VStack(spacing: ValoraSpacing.lg) {
                    if !requested {
                        PrimaryButton(
                            title: String(localized: "onboarding.notification.enable", defaultValue: "Turn On Notifications"),
                            action: {
                                onRequestPermission()
                                withAnimation(.spring(duration: 0.4)) {
                                    requested = true
                                }
                            }
                        )

                        Button {
                            onSkip()
                        } label: {
                            Text(String(localized: "onboarding.notification.skip", defaultValue: "Not Now"))
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        PrimaryButton(
                            title: String(localized: "onboarding.notification.continue", defaultValue: "Continue"),
                            action: onNext
                        )
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, ValoraSpacing.xxl)
            }
            .padding(.vertical, ValoraSpacing.lg)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(duration: 0.6)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                bellBounce = true
            }
        }
    }

    @ViewBuilder
    private func mockNotificationCard() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "leaf.fill")
                    .font(.caption)
                    .foregroundStyle(ValoraColors.accent)
                Text("Valora")
                    .font(.subheadline.bold())
                Spacer()
                Text(String(localized: "onboarding.notification.mock.time", defaultValue: "now"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(String(localized: "onboarding.notification.mock.title", defaultValue: "Your Milk expires tomorrow!"))
                .font(.subheadline)

            Text(String(localized: "onboarding.notification.mock.body", defaultValue: "Use it today before it goes to waste."))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(ValoraSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}
