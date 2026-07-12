import SwiftUI

struct OptionCardView: View {
  let option: Option
  let onTap: () -> Void
  let onFavorite: () -> Void
  let onDelete: () -> Void

  var body: some View {
    OptionCell(
      option: option,
      onTap: onTap,
      onFavorite: onFavorite,
      onDelete: onDelete
    )
  }
}
