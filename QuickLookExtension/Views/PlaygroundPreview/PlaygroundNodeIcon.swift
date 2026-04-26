import SwiftUI

struct PlaygroundNodeIcon: View {
    let node: PlaygroundNode
    var iconName: String = ""
    var foregroundStyle: Color = .primary
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundStyle(foregroundStyle)
    }
    
    init(for node: PlaygroundNode) {
        self.node = node
        
        switch node.previewType {
        case .playgroundPage:
            iconName = "swift"
            foregroundStyle = .blue
        case .swiftSource:
            iconName = "swift"
            foregroundStyle = .orange
        case .text, .metadata:
            iconName = "doc.plaintext"
        case .image:
            iconName = "photo"
        case .directory:
            iconName = "folder"
        case .unknownBinary:
            iconName = "questionmark"
        }
    }
}
