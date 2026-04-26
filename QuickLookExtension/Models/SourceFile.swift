import Foundation

struct SourceFile: Hashable {
    enum SourceLanguage {
        case swift
        case plain
    }
    
    let language: SourceLanguage
    let contents: String
}
