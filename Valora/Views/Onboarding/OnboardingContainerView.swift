import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel: OnboardingViewModel
    @State private var path: [OnboardingStep] = []
    var onComplete: () -> Void

    init(
        preferencesRepository: PreferencesRepository,
        notificationService: NotificationService,
        onComplete: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: OnboardingViewModel(
            preferencesRepository: preferencesRepository,
            notificationService: notificationService
        ))
        self.onComplete = onComplete
    }

    var body: some View {
        NavigationStack(path: $path) {
            OnboardingWelcomeView {
                path.append(.storage)
            }
            .navigationDestination(for: OnboardingStep.self) { step in
                switch step {
                case .storage:
                    OnboardingStorageView(
                        selectedLocations: Binding(
                            get: { viewModel.selectedStorageLocations },
                            set: { viewModel.selectedStorageLocations = $0 }
                        ),
                        onNext: { path.append(.frequency) }
                    )

                case .frequency:
                    OnboardingFrequencyView(
                        selectedFrequency: Binding(
                            get: { viewModel.selectedFrequency },
                            set: { viewModel.selectedFrequency = $0 }
                        ),
                        onNext: { path.append(.notifications) }
                    )

                case .notifications:
                    OnboardingNotificationView(
                        onRequestPermission: {
                            Task { await viewModel.requestNotificationPermission() }
                        },
                        permissionGranted: viewModel.notificationPermissionGranted,
                        onNext: { path.append(.ready) },
                        onSkip: { path.append(.ready) }
                    )

                case .ready:
                    OnboardingReadyView(
                        storagesSummary: viewModel.storageLocationsSummary,
                        frequency: viewModel.selectedFrequency,
                        notificationsEnabled: viewModel.notificationPermissionGranted,
                        onComplete: {
                            viewModel.completeOnboarding()
                            onComplete()
                        }
                    )
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
