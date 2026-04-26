import Foundation

struct PlistParser {
    func parse(url: URL) throws -> PlistNode {
        let data = try Data(contentsOf: url)
        var format = PropertyListSerialization.PropertyListFormat.xml
        let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: &format)

        return makeNode(key: "Information Property List", value: plist, depth: 0)
    }

    private func makeNode(key: String, value: Any, depth: Int) -> PlistNode {
        if let dictionary = value as? [String: Any] {
            let children = dictionary.keys
                .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
                .map { key in
                    makeNode(key: key, value: dictionary[key] as Any, depth: depth + 1)
                }

            return PlistNode(id: UUID(), key: key, depth: depth, value: .dictionary(children.count), children: children)
        }

        if let dictionary = value as? NSDictionary {
            let keys = dictionary.allKeys.compactMap { $0 as? String }
                .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
            let children = keys.map { key in
                makeNode(key: key, value: dictionary[key] as Any, depth: depth + 1)
            }

            return PlistNode(id: UUID(), key: key, depth: depth, value: .dictionary(children.count), children: children)
        }

        if let array = value as? [Any] {
            let children = array.enumerated().map { index, item in
                makeNode(key: "Item \(index)", value: item, depth: depth + 1)
            }

            return PlistNode(id: UUID(), key: key, depth: depth, value: .array(children.count), children: children)
        }

        if let string = value as? String {
            return PlistNode(id: UUID(), key: key, depth: depth, value: .string(string), children: [])
        }

        if let date = value as? Date {
            return PlistNode(id: UUID(), key: key, depth: depth, value: .date(date), children: [])
        }

        if let data = value as? Data {
            return PlistNode(id: UUID(), key: key, depth: depth, value: .data(data.count), children: [])
        }

        if let number = value as? NSNumber {
            if CFGetTypeID(number) == CFBooleanGetTypeID() {
                return PlistNode(id: UUID(), key: key, depth: depth, value: .bool(number.boolValue), children: [])
            }

            return PlistNode(id: UUID(), key: key, depth: depth, value: .number(number.stringValue), children: [])
        }

        return PlistNode(id: UUID(), key: key, depth: depth, value: .unknown(String(describing: value)), children: [])
    }
}
