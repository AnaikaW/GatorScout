import SwiftUI

@main
struct GatorScoutApp: App {
    @StateObject private var networkMonitor = NetworkMonitor.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
            .preferredColorScheme(.light)
            .onAppear {
                _ = NetworkMonitor.shared // Ensure it's initialized
            }
        }
    }
}
