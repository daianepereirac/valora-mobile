import SwiftUI
import SwiftData
import UserNotifications

@main
struct ValoraApp: App {
    @State private var router = AppRouter()
    @State private var dependencies: AppDependencies?
    @State private var showOnboarding = false
    @State private var isReady = false

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FoodItem.self,
            UserPreferences.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if isReady, let dependencies {
                    if showOnboarding {
                        OnboardingContainerView(
                            preferencesRepository: dependencies.preferencesRepository,
                            notificationService: dependencies.notificationService,
                            onComplete: {
                                withAnimation {
                                    showOnboarding = false
                                }
                            }
                        )
                    } else {
                        MainTabView()
                    }
                } else {
                    Color.clear
                }
            }
            .environment(router)
            .environment(dependencies ?? makeTemporaryDependencies())
            .onAppear {
                setupApp()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    rescheduleShoppingRemindersIfNeeded()
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }

    @Environment(\.scenePhase) private var scenePhase

    private func setupApp() {
        let context = sharedModelContainer.mainContext
        let deps = AppDependencies(modelContext: context)
        self.dependencies = deps

        let prefs = deps.preferencesRepository.getOrCreate()
        showOnboarding = !prefs.onboardingCompleted
        isReady = true

        // Set up notification delegate
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        NotificationDelegate.shared.onNotificationTapped = { userInfo in
            if let deepLink = DeepLinkHandler.parse(userInfo: userInfo) {
                router.handle(deepLink: deepLink)
            }
        }
    }

    private func rescheduleShoppingRemindersIfNeeded() {
        guard let dependencies else { return }
        let prefs = dependencies.preferencesRepository.getOrCreate()
        guard prefs.shoppingReminderEnabled else { return }

        let frequency = prefs.shoppingFrequency
        if frequency == .biweekly || frequency == .monthly {
            Task {
                _ = await dependencies.notificationService.scheduleShoppingReminder(
                    frequency: frequency,
                    hour: prefs.shoppingReminderHour,
                    minute: prefs.shoppingReminderMinute
                )
            }
        }
    }

    private func makeTemporaryDependencies() -> AppDependencies {
        AppDependencies(modelContext: sharedModelContainer.mainContext)
    }
}

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, @unchecked Sendable {
    static let shared = NotificationDelegate()
    var onNotificationTapped: (([AnyHashable: Any]) -> Void)?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        await MainActor.run {
            onNotificationTapped?(userInfo)
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .badge, .sound]
    }
}
