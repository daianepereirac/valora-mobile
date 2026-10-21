import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, ValoraSpacing.md)
        }
        .buttonStyle(.borderedProminent)
        .tint(ValoraColors.accent)
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Get Started", action: {})
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
}
