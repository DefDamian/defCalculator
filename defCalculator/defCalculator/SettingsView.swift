import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: Binding(
                    get: { themeManager.themeStyle },
                    set: { themeManager.themeStyle = $0 }
                )) {
                    ForEach(ThemeStyle.allCases) { style in
                        Text(style.label).tag(style)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Accent Color")) {
                ColorPicker("Button Color", selection: Binding(
                    get: { themeManager.accentColor },
                    set: { themeManager.updateAccentColor(to: $0) }
                ))
            }
        }
        .navigationTitle("Settings")
    }
}
