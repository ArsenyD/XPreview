import SwiftUI

struct ContentView: View {
    private let supportedTypes = [".playground", ".plist", ".entitlements", String(localized: .moreToCome)]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header

            instructionSection(
                title: String(localized: .enableTheExtension),
                systemImage: "switch.2",
                rows: [
                    String(localized: .openSystemSettings),
                    String(localized: .goToGeneralLoginItemsExtensions),
                    String(localized: .turnOnXpreviewQuickLookExtension),
                ]
            )

            instructionSection(
                title: String(localized: .useItInFinder),
                systemImage: "doc.viewfinder",
                rows: [
                    String(localized: .selectASupportedFileInFinder),
                    String(localized: .pressSpaceToOpenQuickLook)
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

            Text(String(localized: .quickLookPreviewsForSwiftDevelopers))
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
            Label(String(localized: .supportedFiles), systemImage: "checkmark.circle")
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
