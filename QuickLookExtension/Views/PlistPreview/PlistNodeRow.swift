import SwiftUI

struct PlistNodeRow: View {
    let node: PlistNode
    let columnWidths: PlistColumnWidths
    let isExpanded: Bool
    let hasChildren: Bool
    let onToggle: () -> Void

    private let rowHeight: CGFloat = 24
    private let depthIndent: CGFloat = 14

    var body: some View {
        HStack(spacing: 0) {
            Label {
                Text(node.key)
            } icon: {
                Button(action: onToggle) {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .opacity(hasChildren ? 1 : 0)
                }
                .buttonStyle(.plain)
                .disabled(!hasChildren)
            }
            .lineLimit(1)
            .padding(8 + CGFloat(node.depth) * depthIndent)
            .frame(width: columnWidths.key, alignment: .leading)
            
            Text(node.typeName)
                .lineLimit(1)
                .padding(.leading, 8)
                .frame(width: columnWidths.type, alignment: .leading)

            Text(node.displayValue)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .padding(.leading, 8)
                .frame(width: columnWidths.value, alignment: .leading)
        }
        .font(.system(size: 12))
        .frame(height: rowHeight, alignment: .leading)
    }
}
