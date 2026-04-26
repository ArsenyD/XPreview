import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: PlaygroundPreviewViewModel
    
    private var sourcesNode: PlaygroundNode? {
        viewModel.bundle?.rootNode.children.first(where: { $0.name == "Sources" && $0.previewType == .directory })
    }
    
    private var resourcesNode: PlaygroundNode? {
        viewModel.bundle?.rootNode.children.first(where: { $0.name == "Resources" && $0.previewType == .directory })
    }
    
    private var pageNodes: [PlaygroundNode]? {
        viewModel.bundle?.nodes.filter({ $0.previewType == .playgroundPage })
    }
    
    var body: some View {
        List(selection: $viewModel.selectedNodeId) {
            if let pageNodes {
                sectionForFolder("Pages", children: pageNodes)
            }
            
            if let sourcesNode {
                sectionForFolder("Sources", children: sourcesNode.children)
            }
            
            if let resourcesNode {
                sectionForFolder("Resources", children: resourcesNode.children)
            }
        }
        .listStyle(.sidebar)
    }
    
    private func sectionForFolder(_ title: String, children: [PlaygroundNode]) -> some View {
        Section(title) {
            OutlineGroup(children, children: \.outlineChildren) { node in
                sidebarRow(for: node)
            }
        }
    }
    
    @ViewBuilder
    private func sidebarRow(for node: PlaygroundNode) -> some View {
        Label {
            Text(node.name)
                .foregroundStyle(.primary)
        } icon: {
            PlaygroundNodeIcon(for: node)
        }
        .tag(node.id)
    }
}
