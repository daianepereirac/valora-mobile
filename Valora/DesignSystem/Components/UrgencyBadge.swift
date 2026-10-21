import SwiftUI

struct UrgencyBadge: View {
    let status: FoodStatus
    let daysUntilExpiration: Int

    var body: some View {
        Text(badgeText)
            .font(.caption.weight(.semibold))
            .foregroundStyle(status.color)
            .padding(.horizontal, ValoraSpacing.sm)
            .padding(.vertical, ValoraSpacing.xs)
            .glassEffect(
                .regular.tint(status.color.opacity(0.12)),
                in: .capsule
            )
    }

    private var badgeText: String {
        switch status {
        case .expired:
            return String(localized: "badge.expired", defaultValue: "Expired")
        case .today:
            return String(localized: "badge.today", defaultValue: "Today")
        case .soon:
            let days = daysUntilExpiration
            return days == 1
                ? String(localized: "badge.tomorrow", defaultValue: "Tomorrow")
                : String(format: String(localized: "badge.days", defaultValue: "%lld days"), days)
        case .ok:
            let days = daysUntilExpiration
            return String(format: String(localized: "badge.days", defaultValue: "%lld days"), days)
        }
    }
}
