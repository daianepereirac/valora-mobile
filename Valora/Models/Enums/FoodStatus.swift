import SwiftUI

enum FoodStatus: String, CaseIterable {
    case expired
    case today
    case soon
    case ok

    static func from(expirationDate: Date, now: Date = .now) -> FoodStatus {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let startOfExpiration = calendar.startOfDay(for: expirationDate)
        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfExpiration).day ?? 0

        if days < 0 { return .expired }
        if days == 0 { return .today }
        if days <= 3 { return .soon }
        return .ok
    }

    var sortOrder: Int {
        switch self {
        case .expired: 0
        case .today: 1
        case .soon: 2
        case .ok: 3
        }
    }

    var color: Color {
        switch self {
        case .expired: Color(.statusRed)
        case .today: Color(.statusAmber)
        case .soon: Color(.statusAmber)
        case .ok: Color(.brandGreenLight)
        }
    }

    var sectionTitle: String {
        switch self {
        case .expired: String(localized: "status.expired", defaultValue: "Expired")
        case .today: String(localized: "status.today", defaultValue: "Expires Today")
        case .soon: String(localized: "status.soon", defaultValue: "Expiring Soon")
        case .ok: String(localized: "status.ok", defaultValue: "Within Date")
        }
    }

    var iconName: String {
        switch self {
        case .expired: "exclamationmark.triangle.fill"
        case .today: "clock.fill"
        case .soon: "clock.badge.exclamationmark.fill"
        case .ok: "checkmark.circle.fill"
        }
    }
}
