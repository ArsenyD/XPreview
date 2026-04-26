import SwiftUI

@main
struct XPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 500, height: 500)
        }
        .windowResizability(.contentSize)
    }
}
