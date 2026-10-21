import Foundation
import SwiftData

@Observable
final class FoodRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll(includeConsumed: Bool = false) -> [FoodItem] {
        let predicate: Predicate<FoodItem>? = includeConsumed
            ? nil
            : #Predicate<FoodItem> { !$0.isConsumed }

        var descriptor = FetchDescriptor<FoodItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.expirationDate, order: .forward)]
        )
        descriptor.fetchLimit = nil

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }

    func fetch(byID id: UUID) -> FoodItem? {
        let predicate = #Predicate<FoodItem> { $0.id == id }
        var descriptor = FetchDescriptor<FoodItem>(predicate: predicate)
        descriptor.fetchLimit = 1

        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            return nil
        }
    }

    func insert(_ item: FoodItem) {
        modelContext.insert(item)
        save()
    }

    func update(_ item: FoodItem) {
        item.updatedAt = .now
        save()
    }

    func delete(_ item: FoodItem) {
        modelContext.delete(item)
        save()
    }

    func markAsConsumed(_ item: FoodItem) {
        item.isConsumed = true
        item.consumedAt = .now
        item.updatedAt = .now
        save()
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("FoodRepository save error: \(error)")
        }
    }
}
