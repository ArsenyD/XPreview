import SwiftUI

@main
struct XPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 550, height: 550)
        }
        .windowResizability(.contentSize)
    }
}

