import Foundation
import SwiftData

@Observable
final class PreferencesRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getOrCreate() -> UserPreferences {
        let descriptor = FetchDescriptor<UserPreferences>()
        if let existing = try? modelContext.fetch(descriptor).first {
            return existing
        }
        let prefs = UserPreferences()
        modelContext.insert(prefs)
        save()
        return prefs
    }

    func save() {
        do {
            try modelContext.save()
        } catch {
            print("PreferencesRepository save error: \(error)")
        }
    }
}
