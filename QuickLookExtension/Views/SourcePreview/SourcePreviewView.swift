import SwiftUI

struct SourcePreviewView: View {
    @State private var text: String = ""
    
    let node: PlaygroundNode
    
    var body: some View {
        SourceTextView(sourceFile: SourceFile(
                language: node.previewType == .swiftSource ? .swift : .plain,
                contents: text
            )
        )
            .task(id: node.id) {
                text = FileTextLoader.loadText(from: node.url) ?? "Unable to read text content."
            }
    }
}
