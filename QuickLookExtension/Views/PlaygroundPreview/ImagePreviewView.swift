import AppKit
import SwiftUI

struct ImagePreviewView: View {
    let node: PlaygroundNode

    var body: some View {
        if let image = NSImage(contentsOf: node.url) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            UnavailablePreviewView()
        }
    }
}
