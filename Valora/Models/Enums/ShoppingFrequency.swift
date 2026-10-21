import Foundation

enum ShoppingFrequency: String, CaseIterable, Codable, Identifiable {
    case daily = "daily"
    case twiceWeekly = "twice_weekly"
    case weekly = "weekly"
    case biweekly = "biweekly"
    case monthly = "monthly"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .daily: String(localized: "frequency.daily", defaultValue: "Every day")
        case .twiceWeekly: String(localized: "frequency.twiceWeekly", defaultValue: "Twice a week")
        case .weekly: String(localized: "frequency.weekly", defaultValue: "Once a week")
        case .biweekly: String(localized: "frequency.biweekly", defaultValue: "Every two weeks")
        case .monthly: String(localized: "frequency.monthly", defaultValue: "Once a month")
        }
    }

    var calendarDayInterval: Int {
        switch self {
        case .daily: 1
        case .twiceWeekly: 3
        case .weekly: 7
        case .biweekly: 14
        case .monthly: 30
        }
    }
}
