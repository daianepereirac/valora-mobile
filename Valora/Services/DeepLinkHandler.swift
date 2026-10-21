import Foundation

enum DeepLinkHandler {
    static func parse(userInfo: [AnyHashable: Any]) -> DeepLink? {
        guard let type = userInfo["type"] as? String else { return nil }

        switch type {
        case "expiration":
            guard let idString = userInfo["foodItemID"] as? String,
                  let uuid = UUID(uuidString: idString) else {
                return nil
            }
            return .foodDetail(uuid)
        case "shopping":
            return nil // Just open the app to pantry
        default:
            return nil
        }
    }
}
