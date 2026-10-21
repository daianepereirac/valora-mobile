import SwiftUI

enum ValoraColors {
    static let accent = Color(.brandGreen)
    static let secondaryAccent = Color(.brandGreenLight)
    static let cream = Color(.brandCream)
    static let beige = Color(.brandBeige)
    static let charcoal = Color(.brandCharcoal)
    static let amber = Color(.statusAmber)
    static let red = Color(.statusRed)

    static func statusColor(for status: FoodStatus) -> Color {
        status.color
    }
}
