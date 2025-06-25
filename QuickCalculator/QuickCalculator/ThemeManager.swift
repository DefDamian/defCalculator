import SwiftUI

enum ThemeStyle: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var scheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light Mode"
        case .dark: return "Dark Mode"
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("themeStyle") var themeStyleRaw: String = ThemeStyle.system.rawValue
    @AppStorage("accentColor") var accentColorHex: String = Color.orange.toHex ?? "#FFA500"

    var themeStyle: ThemeStyle {
        get { ThemeStyle(rawValue: themeStyleRaw) ?? .system }
        set { themeStyleRaw = newValue.rawValue }
    }

    var currentScheme: ColorScheme? {
        themeStyle.scheme
    }

    var accentColor: Color {
        Color(hex: accentColorHex) ?? .orange
    }

    func updateAccentColor(to newColor: Color) {
        accentColorHex = newColor.toHex ?? "#FFA500"
    }
}
