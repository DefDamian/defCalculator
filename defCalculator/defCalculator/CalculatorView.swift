import SwiftUI
import SwiftData

struct CalculatorView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var model: CalculatorModel
    @StateObject private var themeManager = ThemeManager()
    @State private var showSettings = false

    init(context: ModelContext) {
        _model = StateObject(wrappedValue: CalculatorModel(context: context))
    }

    var body: some View {
        NavigationView {
            CalculatorViewBody(model: model, themeManager: themeManager, showSettings: $showSettings)
                .navigationBarHidden(true)
                .sheet(isPresented: $showSettings) {
                    NavigationView {
                        SettingsView()
                            .environmentObject(themeManager)
                            .preferredColorScheme(themeManager.themeStyle == .system ? nil : themeManager.currentScheme)
                    }
                }
        }
        .preferredColorScheme(themeManager.themeStyle == .system ? nil : themeManager.currentScheme)
    }
}

private struct CalculatorViewBody: View {
    @ObservedObject var model: CalculatorModel
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var showSettings: Bool

    let buttons: [[CalculatorButton]] = [
        [.function("√"), .function("x²"), .function("log"), .function("ln")],
        [.clear, .plusMinus, .percent, .operation("/")],
        [.digit("7"), .digit("8"), .digit("9"), .operation("×")],
        [.digit("4"), .digit("5"), .digit("6"), .operation("−")],
        [.digit("1"), .digit("2"), .digit("3"), .operation("+")],
        [.digit("0"), .decimal, .equals]
    ]

    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .padding(.trailing)
                            .accessibilityLabel("Open Settings")
                    }
                }

                HStack {
                    Spacer()
                    Text(model.display)
                        .font(.system(size: 64))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding()
                        .accessibilityLabel("Current calculation result")
                }

                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(button: button) {
                                model.receiveInput(button)
                            }
                            .environmentObject(themeManager)
                        }
                    }
                }
            }
            .padding()
        }
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color(UIColor.systemBackground)
    }
}
