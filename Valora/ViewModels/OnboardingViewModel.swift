import Foundation

enum OnboardingStep: Int, Hashable, CaseIterable {
    case storage
    case frequency
    case notifications
    case ready
}

@Observable
final class OnboardingViewModel {
    private let preferencesRepository: PreferencesRepository
    private let notificationService: NotificationService

    var selectedStorageLocations: Set<StorageLocation> = [.fridge]
    var selectedFrequency: ShoppingFrequency = .weekly
    var notificationPermissionGranted = false

    init(
        preferencesRepository: PreferencesRepository,
        notificationService: NotificationService
    ) {
        self.preferencesRepository = preferencesRepository
        self.notificationService = notificationService
    }

    func requestNotificationPermission() async {
        notificationPermissionGranted = await notificationService.requestPermission()
        let prefs = preferencesRepository.getOrCreate()
        prefs.notificationsPermissionKnown = true
        preferencesRepository.save()
    }

    func completeOnboarding() {
        let prefs = preferencesRepository.getOrCreate()
        prefs.shoppingFrequency = selectedFrequency
        prefs.onboardingCompleted = true
        preferencesRepository.save()

        if notificationPermissionGranted && prefs.shoppingReminderEnabled {
            Task {
                _ = await notificationService.scheduleShoppingReminder(
                    frequency: selectedFrequency,
                    hour: prefs.shoppingReminderHour,
                    minute: prefs.shoppingReminderMinute
                )
            }
        }
    }

    var storageLocationsSummary: String {
        selectedStorageLocations
            .sorted { $0.rawValue < $1.rawValue }
            .map(\.displayName)
            .joined(separator: ", ")
    }
}
