import AppKit
import Quartz
import SwiftUI

final class PreviewViewController: NSViewController, QLPreviewingController {
    private let previewingController = PreviewingController()
    
    private lazy var hostingView = {
        let v = NSHostingView(rootView: PreviewRootView(
            viewModel: previewingController.viewModel
        ))
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    override func loadView() {
        view = hostingView
    }

    func preparePreviewOfFile(at url: URL) async throws {
        await previewingController.preparePreviewOfFile(at: url)
    }
}
