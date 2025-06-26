import SwiftUI

enum ThemeStyle: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light Mode"
        case .dark: return "Dark Mode"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

final class ThemeManager: ObservableObject {
    @Published var themeStyle: ThemeStyle = .system
    @Published var accentColor: Color = .blue
    var currentScheme: ColorScheme? { themeStyle.colorScheme }
}
