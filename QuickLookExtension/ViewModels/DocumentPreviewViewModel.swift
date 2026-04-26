import Combine
import Foundation

@MainActor
final class DocumentPreviewViewModel: ObservableObject {
    @Published var kind: PreviewKind = .idle
    
    enum PreviewKind {
        case idle
        case loading
        case playground
        case plist
        case failed(String)
    }
}
