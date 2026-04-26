import Combine
import Foundation

@MainActor
final class PlaygroundPreviewViewModel: ObservableObject {
    enum State {
        case loading
        case presenting
        case failed(String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var bundle: PlaygroundBundle?
    @Published var selectedNodeId: PlaygroundNode.ID?
    
    var selectedNode: PlaygroundNode? {
        guard let bundle else { return nil }
        
        return bundle.nodes.first(where: { $0.id == selectedNodeId })
    }
    
    func load(from url: URL) async {
        do {
            let bundle = try await Task.detached(priority: .userInitiated) {
                try PlaygroundScanner().scan(at: url)
            }.value

            self.bundle = bundle
            if let firstPage = bundle.nodes.filter({ $0.previewType == .playgroundPage }).first {
                selectedNodeId = firstPage.id
                state = .presenting
            } else {
                state = .failed("Empty Playground")
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
