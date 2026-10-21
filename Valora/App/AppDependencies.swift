import SwiftData

@Observable
final class AppDependencies {
    let foodRepository: FoodRepository
    let preferencesRepository: PreferencesRepository
    let notificationService: NotificationService

    init(modelContext: ModelContext) {
        self.foodRepository = FoodRepository(modelContext: modelContext)
        self.preferencesRepository = PreferencesRepository(modelContext: modelContext)
        self.notificationService = NotificationService()
    }
}
