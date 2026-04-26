import Foundation

struct PlaygroundNode: Identifiable, Hashable {
    enum PreviewType: Hashable {
        case playgroundPage
        case swiftSource
        case text
        case image
        case directory
        case metadata
        case unknownBinary
    }
    
    let id: UUID
    let name: String
    let relativePath: String
    let url: URL
    let previewType: PlaygroundNode.PreviewType
    let children: [PlaygroundNode]
    let fileSize: Int64?

    var outlineChildren: [PlaygroundNode]? {
        let visibleChildren = children.filter { child in
            guard previewType == .playgroundPage else { return true }
            
            if child.isPlaygroundPageSource || child.isPlaygroundMetadata {
                return false
            }
            
            if relativePath.isEmpty,
               child.previewType == .directory,
               ["Sources", "Resources"].contains(child.name) {
                return false
            }
            
            return true
        }
        
        return visibleChildren.isEmpty ? nil : visibleChildren
    }
    
    var isPlaygroundPageSource: Bool {
        previewType == .swiftSource && ["Contents.swift", "Content.swift"].contains(name)
    }
    
    private var isPlaygroundMetadata: Bool {
        name.lowercased() == "contents.xcplayground"
    }
}
