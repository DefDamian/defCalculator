import SwiftUI

struct WatchCalculatorView: View {
    @ObservedObject var model = CalculatorModel()

    let buttons: [[CalculatorButton]] = [
        [.digit("7"), .digit("8"), .digit("9"), .operation("/")],
        [.digit("4"), .digit("5"), .digit("6"), .operation("×")],
        [.digit("1"), .digit("2"), .digit("3"), .operation("−")],
        [.digit("0"), .decimal, .equals, .operation("+")]
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 4) {
                // Display result
                Text(model.display)
                    .font(.system(size: 28, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 4)
                    .foregroundColor(.white)

                // AC button row
                Button(action: {
                    model.receiveInput(.clear)
                }) {
                    Text("AC")
                        .font(.system(size: 20, weight: .bold))
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                // Remaining button rows
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                model.receiveInput(button)
                            }) {
                                Text(button.title)
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(buttonBackground(button))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding(6)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func buttonBackground(_ button: CalculatorButton) -> Color {
        switch button {
        case .operation, .equals: return .blue // 🔵 updated
        case .clear: return .red
        default: return Color(white: 0.2)
        }
    }
}
