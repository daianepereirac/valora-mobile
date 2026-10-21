import Foundation

@Observable
final class FoodDetailViewModel {
    private let repository: FoodRepository
    private let notificationService: NotificationService
    private let preferencesRepository: PreferencesRepository

    var item: FoodItem?
    var showDeleteConfirmation = false

    init(
        itemID: UUID,
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        self.repository = repository
        self.notificationService = notificationService
        self.preferencesRepository = preferencesRepository
        self.item = repository.fetch(byID: itemID)
    }

    func markAsConsumed() {
        guard let item else { return }
        notificationService.cancelNotifications(identifiers: item.notificationIdentifiers)
        repository.markAsConsumed(item)
    }

    func delete() {
        guard let item else { return }
        notificationService.cancelNotifications(identifiers: item.notificationIdentifiers)
        repository.delete(item)
        self.item = nil
    }
}
