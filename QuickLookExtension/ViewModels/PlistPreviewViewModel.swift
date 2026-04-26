import Combine
import Foundation

@MainActor
final class PlistPreviewViewModel: ObservableObject {
    enum State {
        case loading
        case presenting
        case failed(String)
    }
    
    @Published private(set) var state: State = .loading
    @Published private(set) var rootNode: PlistNode?

    func load(from url: URL) async {
        do {
            rootNode = try await Task.detached(priority: .userInitiated) {
                try PlistParser().parse(url: url)
            }.value
            
            state = .presenting
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
