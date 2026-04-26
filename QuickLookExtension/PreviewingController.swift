import Foundation

@MainActor
class PreviewingController {
    let viewModel = PreviewViewModel()
    
    func preparePreviewOfFile(at url: URL) async {
        switch url.pathExtension.lowercased() {
        case "playground":
            let playgroundViewModel = PlaygroundPreviewViewModel()
            await playgroundViewModel.load(from: url)

            viewModel.model = .playground(playgroundViewModel)
        case "plist", "entitlements":
            let plistViewModel = PlistPreviewViewModel()
            await plistViewModel.load(from: url)

            viewModel.model = .plist(plistViewModel)
        default:
            viewModel.model = .unsupported
        }
    }
}
