import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(button.title)
                .font(.system(size: 32))
                .frame(width: self.buttonWidth, height: self.buttonHeight)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(self.buttonWidth / 2)
        }
        .disabled(button == .empty)
        .opacity(button == .empty ? 0 : 1) // hide placeholder visually
    }

    private var backgroundColor: Color {
        switch button {
        case .digit, .decimal:
            return Color(.darkGray)
        case .operation, .equals, .function:
            return themeManager.accentColor
        case .clear, .plusMinus, .percent:
            return Color.gray
        case .empty:
            return .clear
        }
    }

    private var buttonWidth: CGFloat {
        if case .digit("0") = button {
            return (UIScreen.main.bounds.width - 5 * 12) / 2
        }
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }

    private var buttonHeight: CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
}
