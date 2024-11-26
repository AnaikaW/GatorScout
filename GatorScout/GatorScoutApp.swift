import SwiftUI

@main
struct GatorScoutApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
            .preferredColorScheme(.light)
        }
    }
}
