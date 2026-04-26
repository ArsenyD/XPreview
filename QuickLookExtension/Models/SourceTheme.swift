import AppKit

enum SourceThemes {
    case defaultTheme(SourceTheme)
}

struct SourceTheme {
    var plainText: NSColor
    var comments: NSColor
    var strings: NSColor
    var keywords: NSColor
    var types: NSColor
    var numbers: NSColor
    var directives: NSColor
    var attributes: NSColor
}

extension SourceTheme {
    static let defaultTheme = SourceTheme(
        plainText: .textColor,
        comments: .secondaryLabelColor,
        strings: .systemOrange,
        keywords: .systemBlue,
        types: .systemPurple,
        numbers: .systemYellow,
        directives: .systemBrown,
        attributes: .systemPink
    )
}
