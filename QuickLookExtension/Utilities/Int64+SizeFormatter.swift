import Foundation

extension Int64? {
    func formattedFilesize() -> String {
        guard let self else { return "" } 
        
        return self.formatted(.byteCount(style: .file))
    }
}
