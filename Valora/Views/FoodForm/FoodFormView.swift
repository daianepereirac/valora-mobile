import SwiftUI

struct FoodFormView: View {
    @State private var viewModel: FoodFormViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    init(
        editingItem: FoodItem? = nil,
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        _viewModel = State(initialValue: FoodFormViewModel(
            editingItem: editingItem,
            repository: repository,
            notificationService: notificationService,
            preferencesRepository: preferencesRepository
        ))
    }

    var body: some View {
        Form {
            Section {
                TextField(
                    String(localized: "foodForm.name.placeholder", defaultValue: "Food name"),
                    text: Binding(
                        get: { viewModel.name },
                        set: { viewModel.name = $0 }
                    )
                )
                .textInputAutocapitalization(.words)

                DatePicker(
                    String(localized: "foodForm.expirationDate", defaultValue: "Expiration Date"),
                    selection: Binding(
                        get: { viewModel.expirationDate },
                        set: { viewModel.expirationDate = $0 }
                    ),
                    displayedComponents: .date
                )
            } header: {
                Text(String(localized: "foodForm.section.required", defaultValue: "Required"))
            }

            Section {
                Picker(
                    String(localized: "foodForm.category", defaultValue: "Category"),
                    selection: Binding(
                        get: { viewModel.category },
                        set: { viewModel.category = $0 }
                    )
                ) {
                    ForEach(FoodCategory.allCases) { category in
                        Label(category.displayName, systemImage: category.iconName)
                            .tag(category)
                    }
                }

                HStack {
                    TextField(
                        String(localized: "foodForm.quantity", defaultValue: "Quantity"),
                        text: Binding(
                            get: { viewModel.quantity },
                            set: { viewModel.quantity = $0 }
                        )
                    )
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 100)

                    Picker(
                        String(localized: "foodForm.unit", defaultValue: "Unit"),
                        selection: Binding(
                            get: { viewModel.unit },
                            set: { viewModel.unit = $0 }
                        )
                    ) {
                        ForEach(MeasurementUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                }

                Picker(
                    String(localized: "foodForm.storage", defaultValue: "Storage"),
                    selection: Binding(
                        get: { viewModel.storageLocation },
                        set: { viewModel.storageLocation = $0 }
                    )
                ) {
                    ForEach(StorageLocation.allCases) { location in
                        Label(location.displayName, systemImage: location.iconName)
                            .tag(location)
                    }
                }
            } header: {
                Text(String(localized: "foodForm.section.optional", defaultValue: "Optional"))
            }

            Section {
                TextField(
                    String(localized: "foodForm.notes.placeholder", defaultValue: "Notes"),
                    text: Binding(
                        get: { viewModel.notes },
                        set: { viewModel.notes = $0 }
                    ),
                    axis: .vertical
                )
                .lineLimit(3...6)
            }
        }
        .scrollContentBackground(.hidden)
        .background { AppBackground() }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(String(localized: "action.cancel", defaultValue: "Cancel")) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(String(localized: "action.save", defaultValue: "Save")) {
                    viewModel.save()
                    dismiss()
                }
                .disabled(!viewModel.isValid)
                .fontWeight(.semibold)
            }
        }
    }
}
