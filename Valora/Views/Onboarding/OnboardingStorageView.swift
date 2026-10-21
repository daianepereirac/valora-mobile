import SwiftUI

struct OnboardingStorageView: View {
    @Binding var selectedLocations: Set<StorageLocation>
    let onNext: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    private let columns = [GridItem(.flexible(), spacing: ValoraSpacing.md), GridItem(.flexible(), spacing: ValoraSpacing.md)]

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: ValoraSpacing.xl) {
                // Navigation + Step
                HStack {
                    backButton { dismiss() }
                    Spacer()
                    OnboardingStepIndicator(currentStep: 1, totalSteps: 4)
                    Spacer()
                    Color.clear.frame(width: 36, height: 36)
                }
                .padding(.horizontal, ValoraSpacing.lg)

                Spacer()

                // Icon
                Image(systemName: "refrigerator.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [ValoraColors.accent, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(appeared ? 1 : 0)

                // Title
                VStack(spacing: ValoraSpacing.sm) {
                    Text(String(localized: "onboarding.storage.title", defaultValue: "Where do you store your food?"))
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text(String(localized: "onboarding.storage.subtitle", defaultValue: "Select all that apply"))
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, ValoraSpacing.lg)
                .opacity(appeared ? 1 : 0)

                Spacer()

                // Storage cards grid
                GlassEffectContainer {
                    LazyVGrid(columns: columns, spacing: ValoraSpacing.md) {
                        ForEach(Array(StorageLocation.allCases.enumerated()), id: \.element.id) { index, location in
                            storageCard(location, index: index)
                        }
                    }
                }
                .padding(.horizontal, ValoraSpacing.xxl)

                Spacer()

                // Continue
                PrimaryButton(
                    title: String(localized: "onboarding.storage.next", defaultValue: "Continue"),
                    action: onNext,
                    isDisabled: selectedLocations.isEmpty
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
        }
    }

    @ViewBuilder
    private func storageCard(_ location: StorageLocation, index: Int) -> some View {
        let isSelected = selectedLocations.contains(location)

        Button {
            withAnimation(.spring(duration: 0.3)) {
                if isSelected {
                    selectedLocations.remove(location)
                } else {
                    selectedLocations.insert(location)
                }
            }
        } label: {
            VStack(spacing: ValoraSpacing.sm) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: location.iconName)
                        .font(.system(size: 32))
                        .foregroundStyle(isSelected ? ValoraColors.accent : .primary)
                        .symbolEffect(.bounce, value: isSelected)
                        .frame(maxWidth: .infinity)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(ValoraColors.accent)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                Text(location.displayName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary)
            }
            .padding(.vertical, ValoraSpacing.xl)
            .padding(.horizontal, ValoraSpacing.md)
            .frame(maxWidth: .infinity)
            .glassEffect(
                isSelected
                    ? .regular.tint(ValoraColors.accent.opacity(0.15))
                    : .regular,
                in: .rect(cornerRadius: 20)
            )
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(duration: 0.5).delay(Double(index) * 0.1), value: appeared)
    }

    @ViewBuilder
    private func backButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.body.bold())
                .padding(ValoraSpacing.sm)
                .glassEffect(.regular.interactive(), in: .circle)
        }
    }
}
