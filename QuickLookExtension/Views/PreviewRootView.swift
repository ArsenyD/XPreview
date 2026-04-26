import SwiftUI

struct PreviewRootView: View {
    @ObservedObject var viewModel: PreviewViewModel
    
    var body: some View {
        switch viewModel.model {
        case nil:
            ProgressView("Loading preview")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .playground(let playgroundPreviewViewModel):
            PlaygroundPreviewRootView(viewModel: playgroundPreviewViewModel)
        case .plist(let plistPreviewViewModel):
            PlistPreviewRootView(viewModel: plistPreviewViewModel)
        case .unsupported:
            UnavailablePreviewView(description: "Preview isn't available.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
