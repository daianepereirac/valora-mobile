import SwiftUI

struct SectionHeader: View {
    let title: String
    let status: FoodStatus

    var body: some View {
        HStack(spacing: ValoraSpacing.sm) {
            Image(systemName: status.iconName)
                .foregroundStyle(
                    LinearGradient(
                        colors: [status.color, status.color.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .font(.subheadline)
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }
}
