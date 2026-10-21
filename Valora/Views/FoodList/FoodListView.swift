import SwiftUI

struct FoodListView: View {
    @State private var viewModel: FoodListViewModel
    @Environment(AppRouter.self) private var router

    init(
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        _viewModel = State(initialValue: FoodListViewModel(
            repository: repository,
            notificationService: notificationService,
            preferencesRepository: preferencesRepository
        ))
    }

    var body: some View {
        ZStack {
            AppBackground()

            if viewModel.groupedItems.isEmpty && viewModel.searchText.isEmpty {
                EmptyStateView(
                    iconName: "refrigerator",
                    title: String(localized: "foodList.empty.title", defaultValue: "Your pantry is empty"),
                    subtitle: String(localized: "foodList.empty.subtitle", defaultValue: "Add your first food item to start tracking expiration dates."),
                    actionTitle: String(localized: "foodList.empty.action", defaultValue: "Add Food"),
                    action: { router.showAddFood() }
                )
            } else if viewModel.groupedItems.isEmpty && !viewModel.searchText.isEmpty {
                EmptyStateView(
                    iconName: "magnifyingglass",
                    title: String(localized: "foodList.noResults.title", defaultValue: "No results"),
                    subtitle: String(localized: "foodList.noResults.subtitle", defaultValue: "No food items match your search.")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: ValoraSpacing.xl) {
                        ForEach(viewModel.groupedItems) { group in
                            VStack(alignment: .leading, spacing: ValoraSpacing.sm) {
                                SectionHeader(title: group.status.sectionTitle, status: group.status)
                                    .padding(.horizontal, ValoraSpacing.xl)

                                VStack(spacing: ValoraSpacing.md) {
                                        ForEach(group.items) { item in
                                            FoodRowView(item: item)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    router.showFoodDetail(item)
                                                }
                                                .contextMenu {
                                                    Button {
                                                        viewModel.markAsConsumed(item)
                                                    } label: {
                                                        Label(
                                                            String(localized: "action.markConsumed", defaultValue: "Mark as Consumed"),
                                                            systemImage: "checkmark.circle"
                                                        )
                                                    }

                                                    Button {
                                                        router.showEditFood(item)
                                                    } label: {
                                                        Label(
                                                            String(localized: "action.edit", defaultValue: "Edit"),
                                                            systemImage: "pencil"
                                                        )
                                                    }

                                                    Divider()

                                                    Button(role: .destructive) {
                                                        viewModel.delete(item)
                                                    } label: {
                                                        Label(
                                                            String(localized: "action.delete", defaultValue: "Delete"),
                                                            systemImage: "trash"
                                                        )
                                                    }
                                                }
                                        }
                                }
                                .padding(.horizontal, ValoraSpacing.lg)
                            }
                        }
                    }
                    .padding(.vertical, ValoraSpacing.md)
                }
            }
        }
        .navigationTitle(String(localized: "foodList.title", defaultValue: "Pantry"))
        .searchable(
            text: Binding(
                get: { viewModel.searchText },
                set: { viewModel.searchText = $0 }
            ),
            prompt: String(localized: "foodList.search.prompt", defaultValue: "Search food items")
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    router.showAddFood()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(String(localized: "foodList.addButton", defaultValue: "Add food item"))
            }
        }
        .onAppear {
            viewModel.loadItems()
        }
        .onChange(of: router.presentedSheet?.id) {
            viewModel.loadItems()
        }
    }
}
