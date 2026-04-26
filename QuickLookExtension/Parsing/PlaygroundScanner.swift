import Foundation

struct PlaygroundScanner {
    private let fileManager = FileManager.default

    func scan(at rootURL: URL) throws -> PlaygroundBundle {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: rootURL.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            throw CocoaError(.fileReadNoSuchFile)
        }

        guard rootURL.pathExtension.lowercased() == "playground" else {
            throw CocoaError(.fileReadUnknown)
        }

        let rootNode = try makeNode(at: rootURL, relativePath: "")
        let allNodes = flatten(node: rootNode)

        return PlaygroundBundle(
            rootNode: rootNode,
            nodes: allNodes
        )
    }

    private func makeNode(at url: URL, relativePath: String) throws -> PlaygroundNode {
        let values = try url.resourceValues(forKeys: [.isDirectoryKey, .fileSizeKey])
        let isDirectory = values.isDirectory ?? false
        let previewType = previewType(for: url, isDirectory: isDirectory)
        let name = previewType == .playgroundPage ? url.deletingPathExtension().lastPathComponent : url.lastPathComponent
        
        var children: [PlaygroundNode] = []
        
        if isDirectory {
            let childURLs = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.isDirectoryKey, .fileSizeKey],
                options: [.skipsHiddenFiles]
            ).sorted { $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending }

            children = try childURLs.map { childURL in
                let childPath = relativePath.isEmpty ? childURL.lastPathComponent : relativePath + "/" + childURL.lastPathComponent
                return try makeNode(at: childURL, relativePath: childPath)
            }
        }
        
        return PlaygroundNode(
            id: UUID(),
            name: name,
            relativePath: relativePath,
            url: url,
            previewType: previewType,
            children: children,
            fileSize: values.fileSize.map(Int64.init)
        )
    }

    // TODO: make the checking better?
    private func previewType(for url: URL, isDirectory: Bool) -> PlaygroundNode.PreviewType {
        if isDirectory {
            if url.pathExtension.lowercased() == "xcplaygroundpage" {
                return .playgroundPage
            }
            
            if url.pathExtension.lowercased() == "playground", hasPageSource(in: url) {
                return .playgroundPage
            }

            return .directory
        }
        
        let fileName = url.lastPathComponent.lowercased()
        let ext = url.pathExtension.lowercased()
        
        if ext == "swift" {
            return .swiftSource
        }
        
        if ["md", "markdown", "txt", "json", "plist", "xml", "yaml", "yml"].contains(ext) {
            return fileName == "contents.xcplayground" ? .metadata : .text
        }
        
        if ["xcplayground", "xcworkspacedata", "pbxproj"].contains(ext) {
            return .metadata
        }
        
        if ["png", "jpg", "jpeg", "gif", "heic", "tiff", "bmp", "pdf"].contains(ext) {
            return .image
        }
        
        return .unknownBinary
    }
    
    private func hasPageSource(in url: URL) -> Bool {
        pageSourceNames.contains { sourceName in
            fileManager.fileExists(atPath: url.appendingPathComponent(sourceName).path)
        }
    }

    private func flatten(node: PlaygroundNode) -> [PlaygroundNode] {
        [node] + node.children.flatMap(flatten)
    }
    
    private let pageSourceNames = ["Contents.swift", "Content.swift"]
}
