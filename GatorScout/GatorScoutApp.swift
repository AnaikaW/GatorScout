import SwiftUI

@main
struct GatorScoutApp: App {
    var body: some Scene {
        WindowGroup {
            ScoutingFormView()
            .preferredColorScheme(.light)  
        }
    }
}
