import UserNotifications

@Observable
final class NotificationService {
    private let center = UNUserNotificationCenter.current()

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func checkPermissionStatus() async -> UNAuthorizationStatus {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

    func scheduleExpirationNotifications(for item: FoodItem, leadDays: Int) async -> [String] {
        var identifiers: [String] = []
        let calendar = Calendar.current

        // Day-of notification
        let dayOfID = "food-\(item.id.uuidString)-day"
        let dayOfDate = calendar.startOfDay(for: item.expirationDate)
        if dayOfDate > Date.now {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: dayOfDate)
            dateComponents.hour = 9
            dateComponents.minute = 0

            let content = UNMutableNotificationContent()
            content.title = String(localized: "notification.expiration.todayTitle", defaultValue: "Expiring Today")
            content.body = "\(item.name) — \(String(localized: "notification.expiration.todayBody", defaultValue: "expires today! Time to use it."))"
            content.sound = .default
            content.userInfo = [
                "type": "expiration",
                "foodItemID": item.id.uuidString,
            ]

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: dayOfID, content: content, trigger: trigger)

            do {
                try await center.add(request)
                identifiers.append(dayOfID)
            } catch {
                print("Failed to schedule day-of notification: \(error)")
            }
        }

        // Lead-time notification
        if leadDays > 0 {
            let leadID = "food-\(item.id.uuidString)-lead"
            guard let leadDate = calendar.date(byAdding: .day, value: -leadDays, to: dayOfDate) else {
                return identifiers
            }

            if leadDate > Date.now {
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: leadDate)
                dateComponents.hour = 9
                dateComponents.minute = 0

                let content = UNMutableNotificationContent()
                content.title = String(localized: "notification.expiration.soonTitle", defaultValue: "Expiring Soon")
                content.body = "\(item.name) — \(String(localized: "notification.expiration.soonBody", defaultValue: "expires soon. Plan to use it!"))"
                content.sound = .default
                content.userInfo = [
                    "type": "expiration",
                    "foodItemID": item.id.uuidString,
                ]

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: leadID, content: content, trigger: trigger)

                do {
                    try await center.add(request)
                    identifiers.append(leadID)
                } catch {
                    print("Failed to schedule lead notification: \(error)")
                }
            }
        }

        return identifiers
    }

    func cancelNotifications(identifiers: [String]) {
        guard !identifiers.isEmpty else { return }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    func scheduleShoppingReminder(
        frequency: ShoppingFrequency,
        hour: Int,
        minute: Int
    ) async -> [String] {
        // Cancel existing shopping reminders first
        cancelShoppingReminders()

        var identifiers: [String] = []

        switch frequency {
        case .daily:
            let id = "shopping-reminder"
            var components = DateComponents()
            components.hour = hour
            components.minute = minute

            let content = makeShoppingContent()
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            do {
                try await center.add(request)
                identifiers.append(id)
            } catch {
                print("Failed to schedule daily shopping reminder: \(error)")
            }

        case .weekly:
            let id = "shopping-reminder"
            var components = DateComponents()
            components.weekday = 7 // Saturday
            components.hour = hour
            components.minute = minute

            let content = makeShoppingContent()
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            do {
                try await center.add(request)
                identifiers.append(id)
            } catch {
                print("Failed to schedule weekly shopping reminder: \(error)")
            }

        case .twiceWeekly:
            for (index, weekday) in [4, 7].enumerated() { // Wednesday + Saturday
                let id = "shopping-reminder-\(index)"
                var components = DateComponents()
                components.weekday = weekday
                components.hour = hour
                components.minute = minute

                let content = makeShoppingContent()
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

                do {
                    try await center.add(request)
                    identifiers.append(id)
                } catch {
                    print("Failed to schedule twice-weekly shopping reminder: \(error)")
                }
            }

        case .biweekly, .monthly:
            let id = "shopping-reminder"
            let calendar = Calendar.current
            let daysToAdd = frequency.calendarDayInterval
            guard let nextDate = calendar.date(byAdding: .day, value: daysToAdd, to: .now) else {
                return identifiers
            }

            var components = calendar.dateComponents([.year, .month, .day], from: nextDate)
            components.hour = hour
            components.minute = minute

            let content = makeShoppingContent()
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            do {
                try await center.add(request)
                identifiers.append(id)
            } catch {
                print("Failed to schedule \(frequency.rawValue) shopping reminder: \(error)")
            }
        }

        return identifiers
    }

    func cancelShoppingReminders() {
        let ids = ["shopping-reminder", "shopping-reminder-0", "shopping-reminder-1"]
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    private func makeShoppingContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = String(localized: "notification.shopping.title", defaultValue: "Shopping Day!")
        content.body = String(
            localized: "notification.shopping.body",
            defaultValue: "Today is your shopping day. Don't forget to add your groceries to Valora."
        )
        content.sound = .default
        content.userInfo = ["type": "shopping"]
        return content
    }
}
