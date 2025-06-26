import SwiftUI

enum CalculatorButton: Hashable {
    case digit(String)
    case operation(String)
    case equals
    case clear
    case plusMinus
    case percent
    case decimal
    case function(String)
    case empty // 👈 placeholder for watch layout only

    var title: String {
        switch self {
        case .digit(let value): return value
        case .operation(let op): return op
        case .equals: return "="
        case .clear: return "AC"
        case .plusMinus: return "±"
        case .percent: return "%"
        case .decimal: return "."
        case .function(let fn): return fn
        case .empty: return ""
        }
    }
}
