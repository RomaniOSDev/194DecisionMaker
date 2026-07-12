import SwiftUI

struct ModeSelectorView: View {
  let onWheel: () -> Void
  let onCoin: () -> Void
  let onDice: () -> Void
  let onElimination: () -> Void
  let onBracket: () -> Void
  let onGuided: () -> Void
  let isOptionsEnabled: Bool
  let isTournamentEnabled: Bool

  private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    VStack(alignment: .leading, spacing: AppSpacing.md) {
      SectionHeader(title: "Decision Modes")

      LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
        ModeGridCell(title: "Wheel", icon: "🎡", color: AppColor.accent, isEnabled: isOptionsEnabled, action: onWheel)
        ModeGridCell(title: "Coin", icon: "🪙", color: Color(hex: "FFD93D"), isEnabled: true, action: onCoin)
        ModeGridCell(title: "Dice", icon: "🎲", color: Color(hex: "6BCB77"), isEnabled: isOptionsEnabled, action: onDice)
        ModeGridCell(title: "Eliminate", icon: "⚔️", color: Color(hex: "FF6B6B"), isEnabled: isTournamentEnabled, action: onElimination)
        ModeGridCell(title: "Bracket", icon: "🏆", color: Color(hex: "A29BFE"), isEnabled: isTournamentEnabled, action: onBracket)
        ModeGridCell(title: "Guided", icon: "🧭", color: Color(hex: "00CEC9"), isEnabled: isOptionsEnabled, action: onGuided)
      }
    }
  }
}
