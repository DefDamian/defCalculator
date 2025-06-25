import SwiftUI
import SwiftData
import Foundation

@main
struct QuickCalculatorWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchCalculatorView() // ✅ CORRECT ENTRY POINT
        }
    }
}
