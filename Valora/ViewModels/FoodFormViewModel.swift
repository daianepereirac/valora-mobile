import Foundation

@Observable
final class FoodFormViewModel {
    private let repository: FoodRepository
    private let notificationService: NotificationService
    private let preferencesRepository: PreferencesRepository
    private let editingItem: FoodItem?

    var name: String = ""
    var expirationDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: .now) ?? .now
    var category: FoodCategory = .other
    var quantity: String = "1"
    var unit: MeasurementUnit = .unit
    var storageLocation: StorageLocation = .fridge
    var notes: String = ""

    var isEditing: Bool { editingItem != nil }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var navigationTitle: String {
        isEditing
            ? String(localized: "foodForm.title.edit", defaultValue: "Edit Food")
            : String(localized: "foodForm.title.add", defaultValue: "Add Food")
    }

    init(
        editingItem: FoodItem? = nil,
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        self.editingItem = editingItem
        self.repository = repository
        self.notificationService = notificationService
        self.preferencesRepository = preferencesRepository

        if let item = editingItem {
            self.name = item.name
            self.expirationDate = item.expirationDate
            self.category = item.category
            self.quantity = item.quantity.truncatingRemainder(dividingBy: 1) == 0
                ? String(format: "%.0f", item.quantity)
                : String(format: "%.1f", item.quantity)
            self.unit = item.unit
            self.storageLocation = item.storageLocation
            self.notes = item.notes
        }
    }

    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let qty = Double(quantity) ?? 1.0
        let prefs = preferencesRepository.getOrCreate()

        if let item = editingItem {
            // Cancel old notifications
            notificationService.cancelNotifications(identifiers: item.notificationIdentifiers)

            item.name = trimmedName
            item.expirationDate = expirationDate
            item.category = category
            item.quantity = qty
            item.unit = unit
            item.storageLocation = storageLocation
            item.notes = notes
            repository.update(item)

            // Reschedule notifications
            if prefs.expirationReminderEnabled {
                Task {
                    let ids = await notificationService.scheduleExpirationNotifications(
                        for: item,
                        leadDays: prefs.expirationReminderLeadDays
                    )
                    item.notificationIdentifiers = ids
                    preferencesRepository.save()
                }
            }
        } else {
            let newItem = FoodItem(
                name: trimmedName,
                expirationDate: expirationDate,
                category: category,
                quantity: qty,
                unit: unit,
                storageLocation: storageLocation,
                notes: notes
            )
            repository.insert(newItem)

            // Schedule notifications
            if prefs.expirationReminderEnabled {
                Task {
                    let ids = await notificationService.scheduleExpirationNotifications(
                        for: newItem,
                        leadDays: prefs.expirationReminderLeadDays
                    )
                    newItem.notificationIdentifiers = ids
                    preferencesRepository.save()
                }
            }
        }
    }
}
