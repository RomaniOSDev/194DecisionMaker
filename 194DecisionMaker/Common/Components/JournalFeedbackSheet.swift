import SwiftUI

struct JournalFeedbackSheet: View {
  @Binding var isPresented: Bool
  let title: String
  let historyId: UUID
  let onSubmit: (SatisfactionRating?, String?) -> Void

  @State private var satisfaction: SatisfactionRating?
  @State private var note = ""

  var body: some View {
    NavigationStack {
      AppScreenShell {
        VStack(spacing: AppSpacing.xl) {
          ScreenHeader(
            emoji: "📓",
            title: "Decision Journal",
            subtitle: "How do you feel about this choice?"
          )

          Text(title)
            .font(.title3.weight(.bold))
            .foregroundColor(AppColor.accent)
            .padding(.horizontal)

          HStack(spacing: AppSpacing.xl) {
            feedbackCell(.positive, label: "Good")
            feedbackCell(.negative, label: "Not great")
          }

          FormFieldSection(title: "Notes") {
            TextField("Add a note...", text: $note, axis: .vertical)
              .lineLimit(3...5)
              .padding(AppSpacing.md)
              .foregroundColor(AppColor.primaryText)
              .appCard(elevation: .flat)
          }
          .padding(.horizontal, AppSpacing.lg)

          VStack(spacing: AppSpacing.sm) {
            PrimaryButton(title: "Save to Journal", icon: "checkmark.circle.fill") {
              onSubmit(satisfaction, note)
              isPresented = false
            }
            Button("Skip") { isPresented = false }
              .font(.subheadline)
              .foregroundColor(AppColor.secondaryText)
          }
          .padding(.horizontal, AppSpacing.lg)

          Spacer()
        }
      }
      .navigationBarTitleDisplayMode(.inline)
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }

  private func feedbackCell(_ rating: SatisfactionRating, label: String) -> some View {
    Button { satisfaction = rating } label: {
      VStack(spacing: AppSpacing.sm) {
        Text(rating.emoji)
          .font(.system(size: 44))
        Text(label)
          .font(.caption.weight(.medium))
          .foregroundColor(AppColor.secondaryText)
      }
      .frame(width: 120)
      .padding(.vertical, AppSpacing.lg)
      .appCard(
        elevation: satisfaction == rating ? .floating : .raised,
        border: satisfaction == rating ? AppColor.accent : AppColor.accent.opacity(0.15),
        tint: satisfaction == rating ? AppColor.accent : nil
      )
    }
  }
}
