import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void

    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Button(action: {
            provideHaptic()
            action()
        }) {
            Text(button.title)
                .font(.system(size: 32, weight: .bold))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(buttonWidth / 2)
                .accessibilityLabel(accessibilityLabel)
                .accessibilityIdentifier("calc_button_\(button.title)")
        }
        .disabled(button == .empty)
        .opacity(button == .empty ? 0 : 1)
    }

    private func provideHaptic() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }

    private var backgroundColor: Color {
        switch button {
        case .digit, .decimal: return Color(.darkGray)
        case .operation, .equals, .function: return themeManager.accentColor
        case .clear, .plusMinus, .percent: return Color.gray
        case .empty: return .clear
        }
    }

    private var accessibilityLabel: String {
        switch button {
        case .digit(let value): return "Digit \(value)"
        case .operation(let op): return "Operation \(op)"
        case .equals: return "Equals"
        case .clear: return "Clear"
        case .plusMinus: return "Plus minus"
        case .percent: return "Percent"
        case .decimal: return "Decimal point"
        case .function(let fn): return "Function \(fn)"
        case .empty: return ""
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
