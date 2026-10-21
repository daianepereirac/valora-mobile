import Foundation

enum MeasurementUnit: String, CaseIterable, Codable, Identifiable {
    case unit = "unit"
    case kg = "kg"
    case g = "g"
    case L = "L"
    case mL = "mL"
    case pack = "pack"
    case dozen = "dozen"
    case bottle = "bottle"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .unit: String(localized: "unit.unit", defaultValue: "unit")
        case .kg: String(localized: "unit.kg", defaultValue: "kg")
        case .g: String(localized: "unit.g", defaultValue: "g")
        case .L: String(localized: "unit.L", defaultValue: "L")
        case .mL: String(localized: "unit.mL", defaultValue: "mL")
        case .pack: String(localized: "unit.pack", defaultValue: "pack")
        case .dozen: String(localized: "unit.dozen", defaultValue: "dozen")
        case .bottle: String(localized: "unit.bottle", defaultValue: "bottle")
        }
    }
}
