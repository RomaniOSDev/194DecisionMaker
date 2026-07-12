import SwiftUI

struct OptionFormView: View {
  @StateObject private var viewModel: OptionFormViewModel
  @FocusState private var isFocused: Bool

  init(viewModel: OptionFormViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    AppScreenShell {
      ScrollView {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(
            emoji: viewModel.isEditing ? "✏️" : "➕",
            title: viewModel.isEditing ? "Edit Option" : "New Option",
            subtitle: "Customize your choice"
          )

          FormFieldSection(title: "Option text") {
            AppTextField(placeholder: "e.g. Go to the movies", text: $viewModel.text)
              .focused($isFocused)
          }

          FormFieldSection(title: "Emoji") {
            EmojiPickerCell(emojis: viewModel.availableEmojis, selected: $viewModel.selectedEmoji)
          }

          FormFieldSection(title: "Color") {
            ColorPickerCell(colors: viewModel.availableColors, selected: $viewModel.selectedColor)
          }

          FormFieldSection(title: "Weight") {
            VStack(spacing: AppSpacing.sm) {
              HStack {
                Text("Priority")
                  .font(.subheadline)
                  .foregroundColor(AppColor.primaryText)
                Spacer()
                TagBadge(text: "\(viewModel.weight)/5", color: AppColor.accent)
              }
              Slider(value: Binding(
                get: { Double(viewModel.weight) },
                set: { viewModel.weight = Int($0.rounded()) }
              ), in: 1...5, step: 1)
              .tint(AppColor.accent)
            }
            .padding(AppSpacing.md)
            .appCard(elevation: .raised, tint: AppColor.accent)
          }

          if !viewModel.collections.isEmpty {
            FormFieldSection(title: "Collection") {
              Picker("Collection", selection: $viewModel.selectedCollectionId) {
                Text("None").tag(UUID?.none)
                ForEach(viewModel.collections) { c in
                  Text("\(c.emoji) \(c.name)").tag(Optional(c.id))
                }
              }
              .pickerStyle(.menu)
              .padding(AppSpacing.md)
              .appCard(elevation: .raised, tint: AppColor.accent)
            }
          }

          FormFieldSection(title: "Guided filters") {
            VStack(spacing: AppSpacing.sm) {
              StepperSettingRow(
                title: "Max time: \(viewModel.estimatedMinutes) min",
                value: $viewModel.estimatedMinutes,
                range: 15...240,
                step: 15
              )
              Picker("Budget", selection: $viewModel.budgetLevel) {
                Text("Low").tag(1)
                Text("Medium").tag(2)
                Text("High").tag(3)
              }
              .pickerStyle(.segmented)
              Picker("Location", selection: $viewModel.indoorSetting) {
                ForEach(OptionFormViewModel.IndoorSetting.allCases, id: \.self) { s in
                  Text(s.rawValue).tag(s)
                }
              }
              .pickerStyle(.segmented)
            }
          }

          ToggleSettingRow(title: "Add to favorites", isOn: $viewModel.isFavorite)

          PrimaryButton(
            title: viewModel.isEditing ? "Save Changes" : "Add Option",
            icon: "checkmark.circle.fill",
            isEnabled: viewModel.isFormValid,
            action: viewModel.saveOption
          )
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.xl)
      }
      .clearScrollBackground()
    }
    .appBackToolbar(action: viewModel.cancel)
    .toolbar {
      ToolbarItem(placement: .principal) {
        Text(viewModel.isEditing ? "Edit" : "Add")
          .font(.headline)
          .foregroundColor(AppColor.primaryText)
      }
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("Done") { isFocused = false }
          .foregroundColor(AppColor.accent)
      }
    }
  }
}
