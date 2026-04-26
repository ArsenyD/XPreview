import Foundation

struct PlistNode: Identifiable, Hashable {
    enum Value: Hashable {
        case dictionary(Int)
        case array(Int)
        case string(String)
        case number(String)
        case bool(Bool)
        case date(Date)
        case data(Int)
        case unknown(String)
    }
    
    let id: UUID
    let key: String
    let depth: Int
    let value: Value
    let children: [PlistNode]

    var outlineChildren: [PlistNode]? {
        children.isEmpty ? nil : children
    }

    var typeName: String {
        switch value {
        case .dictionary:
            return "Dictionary"
        case .array:
            return "Array"
        case .string:
            return "String"
        case .number:
            return "Number"
        case .bool:
            return "Boolean"
        case .date:
            return "Date"
        case .data:
            return "Data"
        case .unknown:
            return "Unknown"
        }
    }

    var displayValue: String {
        switch value {
        case .dictionary(let count):
            return "(\(count) \(count == 1 ? "item" : "items"))"
        case .array(let count):
            return "(\(count) \(count == 1 ? "item" : "items"))"
        case .string(let string):
            return string
        case .number(let number):
            return number
        case .bool(let bool):
            return bool ? "YES" : "NO"
        case .date(let date):
            return PlistNode.dateFormatter.string(from: date)
        case .data(let byteCount):
            return "\(byteCount) \(byteCount == 1 ? "byte" : "bytes")"
        case .unknown(let description):
            return description
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
