import Foundation
import Combine

@MainActor
class PreviewViewModel: ObservableObject {
    enum SupportedVMs {
        case playground(PlaygroundPreviewViewModel)
        case plist(PlistPreviewViewModel)
        case unsupported
    }
    
    @Published var model: SupportedVMs?
    
    init(_ model: SupportedVMs? = nil) {
        self.model = model
    }
}
