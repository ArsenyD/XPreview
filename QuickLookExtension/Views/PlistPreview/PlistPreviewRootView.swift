import AppKit
import SwiftUI

struct PlistPreviewRootView: View {
    @ObservedObject var viewModel: PlistPreviewViewModel
    @State private var expandedNodeIDs: Set<PlistNode.ID> = []

    private let minimumColumnWidth: CGFloat = 220
    private let rowFont = NSFont.systemFont(ofSize: 12)

    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading plist")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .presenting:
            if let rootNode = viewModel.rootNode {
                plistPreview(for: rootNode)
            }
        case .failed(let description):
            UnavailablePreviewView(description: description)
        }
    }

    private func plistPreview(for node: PlistNode) -> some View {
        GeometryReader { proxy in
            let rows = visibleRows(for: node)
            let columnWidths = columnWidths(for: allRows(from: node), viewportWidth: proxy.size.width)
            let contentWidth = columnWidths.key + columnWidths.type + columnWidths.value
            
            ScrollView(.horizontal) {
                VStack(alignment: .leading, spacing: 0) {
                    headerRow(columnWidths: columnWidths)
                        .frame(width: contentWidth, alignment: .leading)
                    
                    Divider()
                    
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(rows.enumerated()), id: \.element.id) { index, node in
                                PlistNodeRow(
                                    node: node,
                                    columnWidths: columnWidths,
                                    isExpanded: expandedNodeIDs.contains(node.id),
                                    hasChildren: !node.children.isEmpty
                                ) {
                                    toggleExpansion(for: node)
                                }
                                
                                if index < rows.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        .frame(
                            minWidth: contentWidth,
                            maxWidth: contentWidth,
                            alignment: .topLeading
                        )
                    }
                    .frame(
                        minWidth: contentWidth,
                        maxWidth: contentWidth,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                }
                .frame(width: contentWidth, height: proxy.size.height, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .background(.background)
    }
    
    private func headerRow(columnWidths: PlistColumnWidths) -> some View {
        HStack(spacing: 0) {
            Text("Key")
                .padding(.leading, 8)
                .frame(width: columnWidths.key, alignment: .leading)
            Text("Type")
                .padding(.leading, 8)
                .frame(width: columnWidths.type, alignment: .leading)
            Text("Value")
                .padding(.leading, 8)
                .frame(width: columnWidths.value, alignment: .leading)
        }
        .font(.caption)
        .bold()
        .padding(.vertical, 6)
        .background(.background)
    }

    private func allRows(from rootNode: PlistNode) -> [PlistNode] {
        var rows = [rootNode]
        for child in rootNode.children {
            rows.append(contentsOf: allRows(from: child))
        }
        return rows
    }

    private func visibleRows(for node: PlistNode) -> [PlistNode] {
        guard expandedNodeIDs.contains(node.id) else {
            return [node]
        }

        var rows = [node]
        for child in node.children {
            rows.append(contentsOf: visibleRows(for: child))
        }
        return rows
    }

    private func toggleExpansion(for node: PlistNode) {
        guard !node.children.isEmpty else { return }

        if expandedNodeIDs.contains(node.id) {
            expandedNodeIDs.remove(node.id)
        } else {
            expandedNodeIDs.insert(node.id)
        }
    }

    private func columnWidths(for rows: [PlistNode], viewportWidth: CGFloat) -> PlistColumnWidths {
        let measuredKeyWidth = rows
            .map { keyWidth(for: $0) }
            .max() ?? minimumColumnWidth
        let measuredTypeWidth = rows
            .map { textWidth(for: $0.typeName) + 16 }
            .max() ?? minimumColumnWidth
        let measuredValueWidth = rows
            .map { textWidth(for: $0.displayValue) + 16 }
            .max() ?? minimumColumnWidth

        var widths = PlistColumnWidths(
            key: max(minimumColumnWidth, measuredKeyWidth),
            type: max(minimumColumnWidth, measuredTypeWidth),
            value: max(minimumColumnWidth, measuredValueWidth)
        )

        let measuredWidth = widths.key + widths.type + widths.value
        guard measuredWidth < viewportWidth else {
            return widths
        }

        let extraWidth = (viewportWidth - measuredWidth) / 3
        widths.key += extraWidth
        widths.type += extraWidth
        widths.value += extraWidth
        return widths
    }

    private func keyWidth(for node: PlistNode) -> CGFloat {
        8 + CGFloat(node.depth) * 14 + 12 + 4 + textWidth(for: node.key) + 8
    }

    private func textWidth(for string: String) -> CGFloat {
        ceil((string as NSString).size(withAttributes: [.font: rowFont]).width)
    }
}

struct PlistColumnWidths {
    var key: CGFloat
    var type: CGFloat
    var value: CGFloat
}
