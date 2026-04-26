import Foundation

struct FileTextLoader {
    static func loadText(from url: URL) -> String? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        for encoding in [String.Encoding.utf8, .utf16, .unicode, .ascii] {
            if let string = String(data: data, encoding: encoding) {
                return string
            }
        }

        return String(decoding: data, as: UTF8.self)
    }
}
