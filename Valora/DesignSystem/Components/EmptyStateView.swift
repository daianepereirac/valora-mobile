import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let subtitle: String
    var actionTitle: String?
    var action: (() -> Void)?

    @State private var appeared = false
    @State private var iconBounce = false

    var body: some View {
        VStack(spacing: ValoraSpacing.xl) {
            Spacer()

            Image(systemName: iconName)
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ValoraColors.accent, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.bounce, value: iconBounce)
                .opacity(appeared ? 1 : 0)
                .scaleEffect(appeared ? 1 : 0.8)

            VStack(spacing: ValoraSpacing.sm) {
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, ValoraSpacing.xxl)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 15)
            .animation(.spring(duration: 0.6).delay(0.15), value: appeared)

            Spacer()

            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.horizontal, ValoraSpacing.xxl)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.spring(duration: 0.6).delay(0.3), value: appeared)
            }

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6)) { appeared = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { iconBounce = true }
        }
    }
}
