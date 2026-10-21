import Foundation
import UserNotifications

@Observable
final class SettingsViewModel {
    private let preferencesRepository: PreferencesRepository
    private let notificationService: NotificationService

    var shoppingReminderEnabled: Bool = true {
        didSet { updateShoppingReminders() }
    }
    var shoppingFrequency: ShoppingFrequency = .weekly {
        didSet { updateShoppingReminders() }
    }
    var shoppingReminderHour: Int = 9
    var shoppingReminderMinute: Int = 0

    var expirationReminderEnabled: Bool = true
    var expirationReminderLeadDays: Int = 2

    var notificationStatus: String = ""
    private var isInitializing = true

    init(
        preferencesRepository: PreferencesRepository,
        notificationService: NotificationService
    ) {
        self.preferencesRepository = preferencesRepository
        self.notificationService = notificationService
        loadPreferences()
        isInitializing = false
    }

    func loadPreferences() {
        let prefs = preferencesRepository.getOrCreate()
        isInitializing = true
        shoppingReminderEnabled = prefs.shoppingReminderEnabled
        shoppingFrequency = prefs.shoppingFrequency
        shoppingReminderHour = prefs.shoppingReminderHour
        shoppingReminderMinute = prefs.shoppingReminderMinute
        expirationReminderEnabled = prefs.expirationReminderEnabled
        expirationReminderLeadDays = prefs.expirationReminderLeadDays
        isInitializing = false
    }

    func savePreferences() {
        let prefs = preferencesRepository.getOrCreate()
        prefs.shoppingReminderEnabled = shoppingReminderEnabled
        prefs.shoppingFrequency = shoppingFrequency
        prefs.shoppingReminderHour = shoppingReminderHour
        prefs.shoppingReminderMinute = shoppingReminderMinute
        prefs.expirationReminderEnabled = expirationReminderEnabled
        prefs.expirationReminderLeadDays = expirationReminderLeadDays
        preferencesRepository.save()
    }

    func checkNotificationStatus() async {
        let status = await notificationService.checkPermissionStatus()
        switch status {
        case .authorized:
            notificationStatus = String(localized: "settings.notifications.authorized", defaultValue: "Enabled")
        case .denied:
            notificationStatus = String(localized: "settings.notifications.denied", defaultValue: "Denied — Open Settings to enable")
        case .notDetermined:
            notificationStatus = String(localized: "settings.notifications.notDetermined", defaultValue: "Not configured")
        default:
            notificationStatus = String(localized: "settings.notifications.unknown", defaultValue: "Unknown")
        }
    }

    private func updateShoppingReminders() {
        guard !isInitializing else { return }
        savePreferences()
        if shoppingReminderEnabled {
            Task {
                _ = await notificationService.scheduleShoppingReminder(
                    frequency: shoppingFrequency,
                    hour: shoppingReminderHour,
                    minute: shoppingReminderMinute
                )
            }
        } else {
            notificationService.cancelShoppingReminders()
        }
    }
}
