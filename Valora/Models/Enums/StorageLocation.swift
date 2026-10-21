import SwiftUI

enum StorageLocation: String, CaseIterable, Codable, Identifiable {
    case fridge = "fridge"
    case freezer = "freezer"
    case pantry = "pantry"
    case other = "other"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fridge: String(localized: "storage.fridge", defaultValue: "Fridge")
        case .freezer: String(localized: "storage.freezer", defaultValue: "Freezer")
        case .pantry: String(localized: "storage.pantry", defaultValue: "Pantry")
        case .other: String(localized: "storage.other", defaultValue: "Other")
        }
    }

    var iconName: String {
        switch self {
        case .fridge: "refrigerator.fill"
        case .freezer: "snowflake"
        case .pantry: "cabinet.fill"
        case .other: "tray.fill"
        }
    }
}
