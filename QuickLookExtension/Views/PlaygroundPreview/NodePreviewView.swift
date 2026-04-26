import SwiftUI

struct NodePreviewView: View {
    @ObservedObject var viewModel: PlaygroundPreviewViewModel

    var body: some View {
        if let node = viewModel.selectedNode {
            switch node.previewType {
            case .playgroundPage:
                if let sourceNode = node.children.first(where: {
                    $0.isPlaygroundPageSource
                }) {
                    SourcePreviewView(node: sourceNode)
                } else {
                    UnavailablePreviewView(description: "Contents.swift is missing")
                }
            case .swiftSource, .text, .metadata:
                SourcePreviewView(node: node)
            case .image:
                ImagePreviewView(node: node)
            case .directory:
                DirectorySummaryView(node: node)
            case .unknownBinary:
                UnavailablePreviewView(description: ".\(node.url.pathExtension) files not supported")
            }
        }
    }
}
