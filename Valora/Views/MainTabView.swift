import SwiftUI

struct MainTabView: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppDependencies.self) private var dependencies

    var body: some View {
        @Bindable var router = router

        TabView(selection: $router.selectedTab) {
            Tab(
                String(localized: "tab.pantry", defaultValue: "Pantry"),
                systemImage: "refrigerator.fill",
                value: .pantry
            ) {
                NavigationStack(path: $router.pantryPath) {
                    FoodListView(
                        repository: dependencies.foodRepository,
                        notificationService: dependencies.notificationService,
                        preferencesRepository: dependencies.preferencesRepository
                    )
                    .navigationDestination(for: UUID.self) { itemID in
                        FoodDetailView(
                            itemID: itemID,
                            repository: dependencies.foodRepository,
                            notificationService: dependencies.notificationService,
                            preferencesRepository: dependencies.preferencesRepository
                        )
                    }
                }
            }

            Tab(
                String(localized: "tab.settings", defaultValue: "Settings"),
                systemImage: "gearshape",
                value: .settings
            ) {
                NavigationStack(path: $router.settingsPath) {
                    SettingsView(
                        preferencesRepository: dependencies.preferencesRepository,
                        notificationService: dependencies.notificationService
                    )
                }
            }
        }
        .tint(ValoraColors.accent)
        .sheet(item: $router.presentedSheet) { sheet in
            sheetContent(for: sheet)
        }
    }

    @ViewBuilder
    private func sheetContent(for sheet: AppSheet) -> some View {
        switch sheet {
        case .addFood:
            NavigationStack {
                FoodFormView(
                    repository: dependencies.foodRepository,
                    notificationService: dependencies.notificationService,
                    preferencesRepository: dependencies.preferencesRepository
                )
            }
        case .editFood(let item):
            NavigationStack {
                FoodFormView(
                    editingItem: item,
                    repository: dependencies.foodRepository,
                    notificationService: dependencies.notificationService,
                    preferencesRepository: dependencies.preferencesRepository
                )
            }
        }
    }
}
