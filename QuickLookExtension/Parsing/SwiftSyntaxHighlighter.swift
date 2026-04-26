import AppKit
import Foundation
import SwiftParser
import SwiftSyntax

enum SwiftSyntaxHighlighter {
    static func highlight(text: String, in attributed: NSMutableAttributedString) {
        let sourceFile = Parser.parse(source: text)
        let visitor = SwiftHighlightVisitor(text: text, attributed: attributed)
        visitor.walk(sourceFile)
    }
}

private final class SwiftHighlightVisitor: SyntaxVisitor {
    private let text: String
    private let attributed: NSMutableAttributedString

    init(text: String, attributed: NSMutableAttributedString) {
        self.text = text
        self.attributed = attributed
        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
        highlight(syntax: node.atSign, color: SourceTheme.defaultTheme.attributes)
        highlight(syntax: node.attributeName, color: SourceTheme.defaultTheme.attributes)
        return .skipChildren
    }

    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        highlightComments(in: token.leadingTrivia, startingAt: token.position)
        highlightComments(in: token.trailingTrivia, startingAt: token.endPositionBeforeTrailingTrivia)

        switch token.tokenKind {
        case .keyword:
            highlight(syntax: token, color: SourceTheme.defaultTheme.keywords)
        case .pound,
             .poundAvailable,
             .poundElse,
             .poundElseif,
             .poundEndif,
             .poundIf,
             .poundSourceLocation,
             .poundUnavailable:
            highlight(syntax: token, color: SourceTheme.defaultTheme.directives)
        case .integerLiteral,
             .floatLiteral:
            highlight(syntax: token, color: SourceTheme.defaultTheme.numbers)
        case .stringQuote,
             .multilineStringQuote,
             .stringSegment,
             .rawStringPoundDelimiter,
             .regexSlash,
             .regexLiteralPattern,
             .regexPoundDelimiter:
            highlight(syntax: token, color: SourceTheme.defaultTheme.strings)
        case .identifier(let identifier) where identifier.first?.isUppercase == true:
            highlight(syntax: token, color: SourceTheme.defaultTheme.types)
        case .atSign:
            highlight(syntax: token, color: SourceTheme.defaultTheme.attributes)
        default:
            break
        }

        return .skipChildren
    }

    private func highlightComments(in trivia: Trivia, startingAt startPosition: AbsolutePosition) {
        var position = startPosition

        for piece in trivia {
            if piece.isComment {
                highlight(startPosition: position, endPosition: position + piece.sourceLength, color: SourceTheme.defaultTheme.comments)
            }

            position += piece.sourceLength
        }
    }

    private func highlight(syntax: some SyntaxProtocol, color: NSColor) {
        highlight(
            startPosition: syntax.positionAfterSkippingLeadingTrivia,
            endPosition: syntax.endPositionBeforeTrailingTrivia,
            color: color
        )
    }

    private func highlight(startPosition: AbsolutePosition, endPosition: AbsolutePosition, color: NSColor) {
        guard startPosition < endPosition,
              startPosition.utf8Offset >= 0,
              endPosition.utf8Offset <= text.utf8.count else {
            return
        }

        let utf8Start = text.utf8.index(text.utf8.startIndex, offsetBy: startPosition.utf8Offset)
        let utf8End = text.utf8.index(text.utf8.startIndex, offsetBy: endPosition.utf8Offset)
        guard let start = String.Index(utf8Start, within: text),
              let end = String.Index(utf8End, within: text) else {
            return
        }

        attributed.addAttribute(.foregroundColor, value: color, range: NSRange(start..<end, in: text))
    }
}
