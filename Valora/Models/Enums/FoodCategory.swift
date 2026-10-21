import SwiftUI

enum FoodCategory: String, CaseIterable, Codable, Identifiable {
    case fruits = "fruits"
    case vegetables = "vegetables"
    case dairy = "dairy"
    case meat = "meat"
    case seafood = "seafood"
    case grains = "grains"
    case bakery = "bakery"
    case frozen = "frozen"
    case canned = "canned"
    case condiments = "condiments"
    case beverages = "beverages"
    case snacks = "snacks"
    case other = "other"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fruits: String(localized: "category.fruits", defaultValue: "Fruits")
        case .vegetables: String(localized: "category.vegetables", defaultValue: "Vegetables")
        case .dairy: String(localized: "category.dairy", defaultValue: "Dairy")
        case .meat: String(localized: "category.meat", defaultValue: "Meat")
        case .seafood: String(localized: "category.seafood", defaultValue: "Seafood")
        case .grains: String(localized: "category.grains", defaultValue: "Grains")
        case .bakery: String(localized: "category.bakery", defaultValue: "Bakery")
        case .frozen: String(localized: "category.frozen", defaultValue: "Frozen")
        case .canned: String(localized: "category.canned", defaultValue: "Canned")
        case .condiments: String(localized: "category.condiments", defaultValue: "Condiments")
        case .beverages: String(localized: "category.beverages", defaultValue: "Beverages")
        case .snacks: String(localized: "category.snacks", defaultValue: "Snacks")
        case .other: String(localized: "category.other", defaultValue: "Other")
        }
    }

    var iconName: String {
        switch self {
        case .fruits: "apple.logo"
        case .vegetables: "leaf.fill"
        case .dairy: "cup.and.saucer.fill"
        case .meat: "fork.knife"
        case .seafood: "fish.fill"
        case .grains: "wheat.bundle.fill"
        case .bakery: "birthday.cake.fill"
        case .frozen: "snowflake"
        case .canned: "shippingbox.fill"
        case .condiments: "drop.fill"
        case .beverages: "waterbottle.fill"
        case .snacks: "popcorn.fill"
        case .other: "basket.fill"
        }
    }

    var color: Color {
        switch self {
        case .fruits: .red
        case .vegetables: Color(.brandGreen)
        case .dairy: .blue
        case .meat: .brown
        case .seafood: .cyan
        case .grains: .orange
        case .bakery: Color(.statusAmber)
        case .frozen: .mint
        case .canned: .gray
        case .condiments: .purple
        case .beverages: .teal
        case .snacks: .pink
        case .other: .secondary
        }
    }
}
