import SwiftUI

struct DirectorySummaryView: View {
    let node: PlaygroundNode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(node.name)
                    .fontWeight(.semibold)
                    .font(.title2)

                ForEach(node.children) { child in
                    HStack {
                        PlaygroundNodeIcon(for: child)
                        Text(child.name)
                        Spacer()
                        Text(child.fileSize.formattedFilesize())
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
    }
    

}
