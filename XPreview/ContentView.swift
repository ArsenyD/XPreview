import SwiftUI

struct ContentView: View {
    private let supportedTypes = [".playground", ".plist", ".entitlements", "more to come!"]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header

            instructionSection(
                title: "Enable The Extension",
                systemImage: "switch.2",
                rows: [
                    "Open System Settings.",
                    "Go to General > Login Items & Extensions.",
                    "Turn on XPreview Quick Look Extension.",
                ]
            )

            instructionSection(
                title: "Use It In Finder",
                systemImage: "doc.viewfinder",
                rows: [
                    "Select a supported file in Finder.",
                    "Press Space to open Quick Look.",
                    "Use Open with Xcode when you need to edit the file."
                ]
            )

            supportedFiles
        }
        .padding(32)
        .frame(minWidth: 520, idealWidth: 560, maxWidth: 640, alignment: .topLeading)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("XPreview")
                .font(.largeTitle)
                .fontWeight(.semibold)

            Text("Quick Look previews for Swift Developers.")
                .foregroundStyle(.secondary)
        }
    }

    private func instructionSection(title: String, systemImage: String, rows: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text("\(index + 1).")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .frame(width: 20, alignment: .trailing)

                        Text(row)
                    }
                }
            }
            .font(.body)
        }
    }

    private var supportedFiles: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Supported Files", systemImage: "checkmark.circle")
                .font(.headline)

            HStack(spacing: 8) {
                ForEach(supportedTypes, id: \.self) { fileType in
                    Text(fileType)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 6))
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
