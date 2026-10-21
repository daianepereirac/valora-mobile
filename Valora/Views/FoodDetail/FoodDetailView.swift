import SwiftUI

struct FoodDetailView: View {
    @State private var viewModel: FoodDetailViewModel
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @State private var appeared = false
    @State private var iconBounce = false

    init(
        itemID: UUID,
        repository: FoodRepository,
        notificationService: NotificationService,
        preferencesRepository: PreferencesRepository
    ) {
        _viewModel = State(initialValue: FoodDetailViewModel(
            itemID: itemID,
            repository: repository,
            notificationService: notificationService,
            preferencesRepository: preferencesRepository
        ))
    }

    var body: some View {
        ZStack {
            AppBackground()

            Group {
                if let item = viewModel.item {
                    ScrollView {
                        VStack(spacing: ValoraSpacing.xl) {
                            headerSection(item: item)
                            infoSection(item: item)
                            actionsSection(item: item)
                        }
                        .padding(ValoraSpacing.lg)
                        .padding(.vertical, ValoraSpacing.md)
                    }
                } else {
                    EmptyStateView(
                        iconName: "questionmark.circle",
                        title: String(localized: "foodDetail.notFound.title", defaultValue: "Item not found"),
                        subtitle: String(localized: "foodDetail.notFound.subtitle", defaultValue: "This food item may have been deleted.")
                    )
                }
            }
        }
        .navigationTitle(viewModel.item?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            String(localized: "foodDetail.delete.title", defaultValue: "Delete Food"),
            isPresented: $viewModel.showDeleteConfirmation
        ) {
            Button(String(localized: "action.cancel", defaultValue: "Cancel"), role: .cancel) {}
            Button(String(localized: "action.delete", defaultValue: "Delete"), role: .destructive) {
                viewModel.delete()
                dismiss()
            }
        } message: {
            Text(String(localized: "foodDetail.delete.message", defaultValue: "Are you sure you want to delete this item? This action cannot be undone."))
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6)) { appeared = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { iconBounce = true }
        }
    }

    @ViewBuilder
    private func headerSection(item: FoodItem) -> some View {
        VStack(spacing: ValoraSpacing.md) {
            Image(systemName: item.category.iconName)
                .font(.system(size: 56))
                .foregroundStyle(
                    LinearGradient(
                        colors: [item.category.color, item.category.color.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .symbolEffect(.bounce, value: iconBounce)

            UrgencyBadge(
                status: item.status,
                daysUntilExpiration: item.daysUntilExpiration
            )

            Text(item.expirationDisplayText)
                .font(.headline)
                .foregroundStyle(item.status.color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, ValoraSpacing.lg)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
    }

    @ViewBuilder
    private func infoSection(item: FoodItem) -> some View {
        VStack(spacing: 0) {
            infoRow(
                icon: "calendar",
                label: String(localized: "foodDetail.expirationDate", defaultValue: "Expiration Date"),
                value: item.expirationDate.formatted(date: .long, time: .omitted)
            )
            Divider().opacity(0.3).padding(.leading, 52)
            infoRow(
                icon: item.category.iconName,
                label: String(localized: "foodDetail.category", defaultValue: "Category"),
                value: item.category.displayName
            )
            Divider().opacity(0.3).padding(.leading, 52)
            infoRow(
                icon: "number",
                label: String(localized: "foodDetail.quantity", defaultValue: "Quantity"),
                value: item.quantityDisplayText
            )
            Divider().opacity(0.3).padding(.leading, 52)
            infoRow(
                icon: item.storageLocation.iconName,
                label: String(localized: "foodDetail.storage", defaultValue: "Storage"),
                value: item.storageLocation.displayName
            )
            if !item.notes.isEmpty {
                Divider().opacity(0.3).padding(.leading, 52)
                infoRow(
                    icon: "note.text",
                    label: String(localized: "foodDetail.notes", defaultValue: "Notes"),
                    value: item.notes
                )
            }
            Divider().opacity(0.3).padding(.leading, 52)
            infoRow(
                icon: "clock",
                label: String(localized: "foodDetail.addedOn", defaultValue: "Added"),
                value: item.createdAt.formatted(date: .abbreviated, time: .omitted)
            )
        }
        .padding(.vertical, ValoraSpacing.sm)
        .glassEffect(.regular, in: .rect(cornerRadius: 16))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(duration: 0.6).delay(0.15), value: appeared)
    }

    @ViewBuilder
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: ValoraSpacing.md) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(
                    LinearGradient(
                        colors: [ValoraColors.accent, .teal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body)
            }

            Spacer()
        }
        .padding(.horizontal, ValoraSpacing.lg)
        .padding(.vertical, ValoraSpacing.md)
    }

    @ViewBuilder
    private func actionsSection(item: FoodItem) -> some View {
        GlassEffectContainer {
            VStack(spacing: ValoraSpacing.sm) {
                if !item.isConsumed {
                    Button {
                        if let url = item.recipeSearchURL {
                            openURL(url)
                        }
                    } label: {
                        Label(
                            String(localized: "action.seeRecipes", defaultValue: "See Recipes"),
                            systemImage: "book.fill"
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, ValoraSpacing.md)
                    }
                    .glassEffect(.regular.tint(ValoraColors.accent.opacity(0.15)), in: .rect(cornerRadius: 12))

                    Button {
                        viewModel.markAsConsumed()
                        dismiss()
                    } label: {
                        Label(
                            String(localized: "action.markConsumed", defaultValue: "Mark as Consumed"),
                            systemImage: "checkmark.circle"
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, ValoraSpacing.md)
                    }
                    .glassEffect(.regular, in: .rect(cornerRadius: 12))
                }

                Button {
                    router.showEditFood(item)
                } label: {
                    Label(
                        String(localized: "action.edit", defaultValue: "Edit"),
                        systemImage: "pencil"
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ValoraSpacing.md)
                }
                .glassEffect(.regular, in: .rect(cornerRadius: 12))

                Button(role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Label(
                        String(localized: "action.delete", defaultValue: "Delete"),
                        systemImage: "trash"
                    )
                    .foregroundStyle(ValoraColors.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, ValoraSpacing.md)
                }
                .glassEffect(.regular.tint(ValoraColors.red.opacity(0.08)), in: .rect(cornerRadius: 12))
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(duration: 0.6).delay(0.3), value: appeared)
    }
}
