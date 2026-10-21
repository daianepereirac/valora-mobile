import SwiftUI

enum AppTab: Hashable {
    case pantry
    case settings
}

enum AppSheet: Identifiable {
    case addFood
    case editFood(FoodItem)

    var id: String {
        switch self {
        case .addFood: "addFood"
        case .editFood(let item): "editFood-\(item.id)"
        }
    }
}

enum DeepLink {
    case foodDetail(UUID)
}

@Observable
final class AppRouter {
    var selectedTab: AppTab = .pantry
    var pantryPath = NavigationPath()
    var settingsPath = NavigationPath()
    var presentedSheet: AppSheet?

    func showFoodDetail(_ item: FoodItem) {
        pantryPath.append(item.id)
    }

    func showAddFood() {
        presentedSheet = .addFood
    }

    func showEditFood(_ item: FoodItem) {
        presentedSheet = .editFood(item)
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func handle(deepLink: DeepLink) {
        switch deepLink {
        case .foodDetail(let id):
            selectedTab = .pantry
            pantryPath = NavigationPath()
            pantryPath.append(id)
        }
    }
}
