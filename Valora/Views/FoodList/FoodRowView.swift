import SwiftUI

struct FoodRowView: View {
    let item: FoodItem

    var body: some View {
        HStack(spacing: ValoraSpacing.md) {
            Image(systemName: item.category.iconName)
                .font(.title3)
                .foregroundStyle(
                    LinearGradient(
                        colors: [item.category.color, item.category.color.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 36, height: 36)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: ValoraSpacing.xs) {
                Text(item.name)
                    .font(.body.weight(.medium))
                    .lineLimit(1)

                HStack(spacing: ValoraSpacing.sm) {
                    Text(item.quantityDisplayText)
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Image(systemName: item.storageLocation.iconName)
                    Text(item.storageLocation.displayName)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            UrgencyBadge(
                status: item.status,
                daysUntilExpiration: item.daysUntilExpiration
            )
        }
        .padding(ValoraSpacing.md)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name), \(item.expirationDisplayText)")
    }
}
