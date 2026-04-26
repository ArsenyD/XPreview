import SwiftUI

struct UnavailablePreviewView: View {
    var description: String?
    
    var body: some View {
        ContentUnavailableView("No preview available", systemImage: "doc.slash", description: descriptionView)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var descriptionView: Text? {
        guard let description else { return nil }
        
        return Text(description)
    }
}
