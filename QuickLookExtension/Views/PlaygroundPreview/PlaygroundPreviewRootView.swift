import SwiftUI

struct PlaygroundPreviewRootView: View {
    @ObservedObject var viewModel: PlaygroundPreviewViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading playground")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            UnavailablePreviewView(description: message)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .presenting:
            NavigationSplitView {
                SidebarView(viewModel: viewModel)
                    .frame(minWidth: 240)
            } detail: {
                NodePreviewView(viewModel: viewModel)
            }
        }
    }
}
