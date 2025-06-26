import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section(header: Text("Theme").bold()) {
                Picker("Theme", selection: $themeManager.themeStyle) {
                    ForEach(ThemeStyle.allCases) { style in
                        Text(style.displayName).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Accent Color").bold()) {
                ColorPicker("Accent", selection: $themeManager.accentColor)
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(themeManager.currentScheme)
    }
}
