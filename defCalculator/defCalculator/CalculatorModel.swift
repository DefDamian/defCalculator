import Foundation
import SwiftUI
import SwiftData

class CalculatorModel: ObservableObject {
    @Published var display: String = "0"
    private var context: ModelContext
    private var expression: String = ""

    init(context: ModelContext) {
        self.context = context
    }

    #if os(watchOS)
    init() {
        do {
            let container = try ModelContainer(for: Item.self)
            self.context = ModelContext(container)
        } catch {
            fatalError("Failed to create ModelContainer for watchOS: \(error)")
        }
    }
    #endif

    func receiveInput(_ input: CalculatorButton) {
        switch input {
        case .digit(let num), .operation(let num):
            appendToExpression(num)

        case .decimal:
            appendToExpression(".")

        case .function(let fn):
            switch fn {
            case "√":
                wrapFunction("sqrt")
            case "x²":
                expression = "(\(expression))^2"
            case "log":
                wrapFunction("log10")
            case "ln":
                wrapFunction("ln")
            default: break
            }

        case .equals:
            evaluateExpression()

        case .clear:
            expression = ""
            display = "0"

        case .plusMinus:
            if let val = Double(display) {
                display = formatResult(-val)
            }

        case .percent:
            if let val = Double(display) {
                display = formatResult(val / 100)
            }

        case .empty:
            break
        }
    }

    private func appendToExpression(_ value: String) {
        expression += value
        display = expression
    }

    private func wrapFunction(_ fn: String) {
        expression = "\(fn)(\(expression))"
        display = expression
    }

    private func evaluateExpression() {
        let formatted = expression.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "−", with: "-")
        let exp = NSExpression(format: formatted)
        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            display = formatResult(result.doubleValue)
            expression = display
            saveToHistory()
        } else {
            display = "Error"
            expression = ""
        }
    }

    private func formatResult(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(value)) : String(value)
    }

    private func saveToHistory() {
        let item = Item(timestamp: .now)
        context.insert(item)
    }
}
