import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel

    init(
        preferencesRepository: PreferencesRepository,
        notificationService: NotificationService
    ) {
        _viewModel = State(initialValue: SettingsViewModel(
            preferencesRepository: preferencesRepository,
            notificationService: notificationService
        ))
    }

    var body: some View {
        Form {
            Section {
                Toggle(
                    String(localized: "settings.shopping.enabled", defaultValue: "Shopping Reminders"),
                    isOn: Binding(
                        get: { viewModel.shoppingReminderEnabled },
                        set: { viewModel.shoppingReminderEnabled = $0 }
                    )
                )
                .tint(ValoraColors.accent)

                if viewModel.shoppingReminderEnabled {
                    Picker(
                        String(localized: "settings.shopping.frequency", defaultValue: "Frequency"),
                        selection: Binding(
                            get: { viewModel.shoppingFrequency },
                            set: { viewModel.shoppingFrequency = $0 }
                        )
                    ) {
                        ForEach(ShoppingFrequency.allCases) { frequency in
                            Text(frequency.displayName).tag(frequency)
                        }
                    }

                    DatePicker(
                        String(localized: "settings.shopping.time", defaultValue: "Reminder Time"),
                        selection: shoppingTimeBinding,
                        displayedComponents: .hourAndMinute
                    )
                }
            } header: {
                Text(String(localized: "settings.section.shopping", defaultValue: "Shopping"))
            }

            Section {
                Toggle(
                    String(localized: "settings.expiration.enabled", defaultValue: "Expiration Reminders"),
                    isOn: Binding(
                        get: { viewModel.expirationReminderEnabled },
                        set: {
                            viewModel.expirationReminderEnabled = $0
                            viewModel.savePreferences()
                        }
                    )
                )
                .tint(ValoraColors.accent)

                if viewModel.expirationReminderEnabled {
                    Stepper(
                        value: Binding(
                            get: { viewModel.expirationReminderLeadDays },
                            set: {
                                viewModel.expirationReminderLeadDays = $0
                                viewModel.savePreferences()
                            }
                        ),
                        in: 1...7
                    ) {
                        HStack {
                            Text(String(localized: "settings.expiration.leadDays", defaultValue: "Remind"))
                            Text("\(viewModel.expirationReminderLeadDays)")
                                .fontWeight(.semibold)
                            Text(String(localized: "settings.expiration.leadDaysSuffix", defaultValue: "days before"))
                        }
                    }
                }
            } header: {
                Text(String(localized: "settings.section.expiration", defaultValue: "Expiration"))
            }

            Section {
                HStack {
                    Text(String(localized: "settings.notifications.status", defaultValue: "Notifications"))
                    Spacer()
                    Text(viewModel.notificationStatus)
                        .foregroundStyle(.secondary)
                }

                if viewModel.notificationStatus.contains("Denied") || viewModel.notificationStatus.contains("Negad") {
                    Button(String(localized: "settings.notifications.openSettings", defaultValue: "Open Settings")) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            } header: {
                Text(String(localized: "settings.section.notifications", defaultValue: "Notifications"))
            }

            Section {
                HStack {
                    Text(String(localized: "settings.about.version", defaultValue: "Version"))
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(String(localized: "settings.section.about", defaultValue: "About"))
            }
        }
        .scrollContentBackground(.hidden)
        .background { AppBackground() }
        .navigationTitle(String(localized: "settings.title", defaultValue: "Settings"))
        .task {
            await viewModel.checkNotificationStatus()
        }
    }

    private var shoppingTimeBinding: Binding<Date> {
        Binding(
            get: {
                var components = DateComponents()
                components.hour = viewModel.shoppingReminderHour
                components.minute = viewModel.shoppingReminderMinute
                return Calendar.current.date(from: components) ?? .now
            },
            set: { newDate in
                let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                viewModel.shoppingReminderHour = components.hour ?? 9
                viewModel.shoppingReminderMinute = components.minute ?? 0
                viewModel.savePreferences()
            }
        )
    }
}
