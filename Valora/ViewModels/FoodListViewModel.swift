import Foundation

struct FoodItemGroup: Identifiable {
    let status: FoodStatus
    let items: [FoodItem]
    var id: String { status.rawValue }
}

@Observable
final class FoodListViewModel {
    private let repository: FoodRepository
    private let notificationService: NotificationService
    private let preferencesRepository: PreferencesRepository

    var searchText: String = "" {
        didSet { filterItems() }
    }

    private(set) var groupedItems: [FoodItemGroup] = []
    private var allItems: [FoodItem] = []

    init(
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        self.repository = repository
        self.notificationService = notificationService
        self.preferencesRepository = preferencesRepository
    }

    func loadItems() {
        allItems = repository.fetchAll()
        filterItems()
    }

    func delete(_ item: FoodItem) {
        notificationService.cancelNotifications(identifiers: item.notificationIdentifiers)
        repository.delete(item)
        loadItems()
    }

    func markAsConsumed(_ item: FoodItem) {
        notificationService.cancelNotifications(identifiers: item.notificationIdentifiers)
        repository.markAsConsumed(item)
        loadItems()
    }

    private func filterItems() {
        let filtered: [FoodItem]
        if searchText.isEmpty {
            filtered = allItems
        } else {
            let query = searchText.lowercased()
            filtered = allItems.filter { $0.name.lowercased().contains(query) }
        }

        let grouped = Dictionary(grouping: filtered) { $0.status }
        let sortedStatuses: [FoodStatus] = [.expired, .today, .soon, .ok]

        groupedItems = sortedStatuses.compactMap { status in
            guard let items = grouped[status], !items.isEmpty else { return nil }
            return FoodItemGroup(status: status, items: items)
        }
    }
}
