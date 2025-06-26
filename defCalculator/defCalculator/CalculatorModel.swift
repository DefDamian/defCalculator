import Foundation
import SwiftUI
import SwiftData

class CalculatorModel: ObservableObject {
    @Published var display: String = "0"
    private var context: ModelContext

    private var currentValue: Double = 0
    private var previousValue: Double?
    private var currentOperation: CalculatorButton?
    private var isTypingNewNumber = true

    // MARK: - Init for iOS
    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Init for watchOS
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

    // MARK: - Input Handling
    func receiveInput(_ input: CalculatorButton) {
        switch input {
        case .digit(let number):
            if isTypingNewNumber {
                display = number
                isTypingNewNumber = false
            } else {
                display += number
            }
            currentValue = Double(display) ?? 0

        case .decimal:
            if isTypingNewNumber {
                display = "0."
                isTypingNewNumber = false
            } else if !display.contains(".") {
                display += "."
            }

        case .operation:
            previousValue = currentValue
            currentOperation = input
            isTypingNewNumber = true

        case .equals:
            guard let operation = currentOperation, let prev = previousValue else { return }
            switch operation {
            case .operation("+"):
                currentValue = prev + currentValue
            case .operation("−"):
                currentValue = prev - currentValue
            case .operation("×"):
                currentValue = prev * currentValue
            case .operation("/"):
                currentValue = currentValue == 0 ? 0 : prev / currentValue
            default:
                break
            }
            display = formatResult(currentValue)
            saveToHistory()
            previousValue = nil
            currentOperation = nil
            isTypingNewNumber = true

        case .function(let fn):
            switch fn {
            case "√":
                currentValue = sqrt(currentValue)
            case "x²":
                currentValue *= currentValue
            case "log":
                currentValue = log10(currentValue)
            case "ln":
                currentValue = log(currentValue)
            default: break
            }
            display = formatResult(currentValue)
            saveToHistory()

        case .clear:
            display = "0"
            currentValue = 0
            previousValue = nil
            currentOperation = nil
            isTypingNewNumber = true

        case .plusMinus:
            currentValue = -currentValue
            display = formatResult(currentValue)

        case .percent:
            currentValue = currentValue / 100
            display = formatResult(currentValue)

        case .empty:
            break // Ignore empty cells
        }
    }

    // MARK: - Helpers

    private func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(value))
        } else {
            return String(value)
        }
    }

    private func saveToHistory() {
        let item = Item(timestamp: .now)
        context.insert(item)
    }
}
