import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void

    @State private var appeared = false
    @State private var iconBounce = false

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: ValoraSpacing.xl) {
                Spacer()

                // Hero icon
                Image(systemName: "leaf.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ValoraColors.accent, .mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce, value: iconBounce)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : -20)

                // Title & subtitle
                VStack(spacing: ValoraSpacing.sm) {
                    Text(String(localized: "onboarding.welcome.title", defaultValue: "Welcome to Valora"))
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.welcome.subtitle", defaultValue: "Let's set up your personal food freshness tracker"))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .padding(.horizontal, ValoraSpacing.lg)

                Spacer()

                // Feature pills with glass effect
                GlassEffectContainer {
                    VStack(spacing: ValoraSpacing.md) {
                        featurePill(
                            icon: "clock.badge.exclamationmark",
                            title: String(localized: "onboarding.welcome.feature1.title", defaultValue: "Track Expiration Dates"),
                            subtitle: String(localized: "onboarding.welcome.feature1.subtitle", defaultValue: "Know exactly when your food expires"),
                            delay: 0.3
                        )
                        featurePill(
                            icon: "bell.badge",
                            title: String(localized: "onboarding.welcome.feature2.title", defaultValue: "Smart Reminders"),
                            subtitle: String(localized: "onboarding.welcome.feature2.subtitle", defaultValue: "Get notified before food goes to waste"),
                            delay: 0.45
                        )
                        featurePill(
                            icon: "book",
                            title: String(localized: "onboarding.welcome.feature3.title", defaultValue: "Find Recipes"),
                            subtitle: String(localized: "onboarding.welcome.feature3.subtitle", defaultValue: "Discover recipes for expiring ingredients"),
                            delay: 0.6
                        )
                    }
                }
                .padding(.horizontal, ValoraSpacing.xl)

                Spacer()

                // CTA
                PrimaryButton(
                    title: String(localized: "onboarding.welcome.next", defaultValue: "Let's Get Started"),
                    action: onNext
                )
                .padding(.horizontal, ValoraSpacing.xxl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 30)
                .animation(.spring(duration: 0.7).delay(0.5), value: appeared)
            }
            .padding(.vertical, ValoraSpacing.xxl)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                iconBounce = true
            }
        }
    }

    @ViewBuilder
    private func featurePill(icon: String, title: String, subtitle: String, delay: Double) -> some View {
        HStack(spacing: ValoraSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(ValoraColors.accent)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(ValoraSpacing.md)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
        .animation(.spring(duration: 0.6).delay(delay), value: appeared)
    }
}
