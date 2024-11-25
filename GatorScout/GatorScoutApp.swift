import SwiftUI

@main
struct GatorScoutApp: App {
    var body: some Scene {
        WindowGroup {
            ScoutingFormView(username: "TestUser") //for testing
            //LoginView()
            .preferredColorScheme(.light)
        }
    }
}
