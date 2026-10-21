import Foundation
import SwiftData
import SwiftUI

@Model
final class FoodItem {
    var id: UUID = UUID()
    var name: String = ""
    var expirationDate: Date = Date.now
    var createdAt: Date = Date.now
    var updatedAt: Date = Date.now

    var categoryRawValue: String = FoodCategory.other.rawValue
    var quantity: Double = 1.0
    var unitRawValue: String = MeasurementUnit.unit.rawValue
    var storageLocationRawValue: String = StorageLocation.fridge.rawValue
    var notes: String = ""

    var isConsumed: Bool = false
    var consumedAt: Date?
    var notificationIdentifiers: [String] = []

    init(
        name: String,
        expirationDate: Date,
        category: FoodCategory = .other,
        quantity: Double = 1.0,
        unit: MeasurementUnit = .unit,
        storageLocation: StorageLocation = .fridge,
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.expirationDate = expirationDate
        self.createdAt = Date.now
        self.updatedAt = Date.now
        self.categoryRawValue = category.rawValue
        self.quantity = quantity
        self.unitRawValue = unit.rawValue
        self.storageLocationRawValue = storageLocation.rawValue
        self.notes = notes
    }

    // MARK: - Type-safe computed properties

    var category: FoodCategory {
        get { FoodCategory(rawValue: categoryRawValue) ?? .other }
        set { categoryRawValue = newValue.rawValue }
    }

    var unit: MeasurementUnit {
        get { MeasurementUnit(rawValue: unitRawValue) ?? .unit }
        set { unitRawValue = newValue.rawValue }
    }

    var storageLocation: StorageLocation {
        get { StorageLocation(rawValue: storageLocationRawValue) ?? .fridge }
        set { storageLocationRawValue = newValue.rawValue }
    }

    var status: FoodStatus {
        if isConsumed { return .ok }
        return FoodStatus.from(expirationDate: expirationDate)
    }

    var daysUntilExpiration: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfExpiration = calendar.startOfDay(for: expirationDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfExpiration).day ?? 0
    }

    var expirationDisplayText: String {
        let days = daysUntilExpiration
        if days < 0 {
            let absDays = abs(days)
            return absDays == 1
                ? String(localized: "expiration.expiredDayAgo", defaultValue: "Expired 1 day ago")
                : String(format: String(localized: "expiration.expiredDaysAgo", defaultValue: "Expired %lld days ago"), absDays)
        }
        if days == 0 {
            return String(localized: "expiration.today", defaultValue: "Expires today")
        }
        if days == 1 {
            return String(localized: "expiration.tomorrow", defaultValue: "Expires tomorrow")
        }
        return String(format: String(localized: "expiration.inDays", defaultValue: "Expires in %lld days"), days)
    }

    var quantityDisplayText: String {
        let formatted = quantity.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", quantity)
            : String(format: "%.1f", quantity)
        return "\(formatted) \(unit.displayName)"
    }

    var recipeSearchURL: URL? {
        let locale = Locale.current
        let languageCode = locale.language.languageCode?.identifier ?? "en"
        let prefix = languageCode == "pt" ? "receitas com" : "recipes with"
        let query = "\(prefix) \(name)"
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: "https://www.google.com/search?q=\(encoded)")
    }
}
