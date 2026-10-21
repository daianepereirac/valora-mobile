import Foundation
import SwiftData

@Model
final class UserPreferences {
    var id: UUID = UUID()

    var onboardingCompleted: Bool = false

    var shoppingFrequencyRawValue: String = ShoppingFrequency.weekly.rawValue
    var shoppingReminderEnabled: Bool = true
    var shoppingReminderHour: Int = 9
    var shoppingReminderMinute: Int = 0

    var expirationReminderEnabled: Bool = true
    var expirationReminderLeadDays: Int = 2

    var notificationsPermissionKnown: Bool = false

    init() {
        self.id = UUID()
    }

    var shoppingFrequency: ShoppingFrequency {
        get { ShoppingFrequency(rawValue: shoppingFrequencyRawValue) ?? .weekly }
        set { shoppingFrequencyRawValue = newValue.rawValue }
    }

    var shoppingReminderTime: DateComponents {
        var components = DateComponents()
        components.hour = shoppingReminderHour
        components.minute = shoppingReminderMinute
        return components
    }
}
