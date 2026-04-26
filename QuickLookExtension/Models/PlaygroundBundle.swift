import Foundation

struct PlaygroundBundle: Hashable {
    struct Metadata: Hashable {
        let totalFileCount: Int
        let sourcesCount: Int
        let resourcesCount: Int
    }
    
    let rootNode: PlaygroundNode
    let nodes: [PlaygroundNode]
}
