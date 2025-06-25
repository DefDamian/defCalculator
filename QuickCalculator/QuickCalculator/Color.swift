import SwiftUI
import UIKit

extension Color {
    init?(hex: String) {
        let r, g, b: CGFloat

        var hexColor = hex
        if hexColor.hasPrefix("#") {
            hexColor = String(hexColor.dropFirst())
        }

        guard hexColor.count == 6, let intVal = Int(hexColor, radix: 16) else { return nil }

        r = CGFloat((intVal >> 16) & 0xFF) / 255
        g = CGFloat((intVal >> 8) & 0xFF) / 255
        b = CGFloat(intVal & 0xFF) / 255

        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }

    var toHex: String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return String(format: "#%02X%02X%02X",
                      Int(red * 255),
                      Int(green * 255),
                      Int(blue * 255))
    }
}
