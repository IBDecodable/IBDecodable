//
//  AttributedString.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct AttributedString: IBDecodable, IBKeyable {

    public let key: String?
    public let fragments: [Fragment]?

    static func decode(_ xml: XMLIndexerType) throws -> AttributedString {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .fragments: return "fragment"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        return AttributedString(
            key:            try container.attribute(of: .key),
            fragments:      container.elementsIfPresent(of: .fragments)
        )
    }

    public struct Fragment: IBDecodable {
        public let content: String
        public let attributes: [AnyAttribute]?

        static func decode(_ xml: XMLIndexerType) throws -> Fragment {
            let container = xml.container(keys: CodingKeys.self)
            return Fragment(
                content:      try container.attribute(of: .content),
                attributes:   container.childrenIfPresent(of: .attributes)
            )
        }
    }

}

// MARK: - AttributeProtocol

public protocol AttributeProtocol: IBKeyable {
    var key: String? { get }
}

// MARK: - AnyAttribute

public struct AnyAttribute: IBDecodable {

    public let attribute: AttributeProtocol

    init(_ attribute: AttributeProtocol) {
        self.attribute = attribute
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexerType) throws -> AnyAttribute {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "font":              return try AnyAttribute(Font.decode(xml))
        case "paragraphStyle":    return try AnyAttribute(ParagraphStyle.decode(xml))
        case "color":             return try AnyAttribute(Color.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }
}

extension AnyAttribute: IBAny {
    public typealias NestedElement = AttributeProtocol
    public var nested: AttributeProtocol {
        return attribute
    }
}

// MARK: - Font

public struct Font: IBDecodable, AttributeProtocol {

    public let key: String?
    public let size: String?
    public let name: String?
    public let metaFont: String?

    static func decode(_ xml: XMLIndexerType) throws -> Font {
        let container = xml.container(keys: CodingKeys.self)
        return Font(
            key:        container.attributeIfPresent(of: .key),
            size:       container.attributeIfPresent(of: .size),
            name:       container.attributeIfPresent(of: .name),
            metaFont:   container.attributeIfPresent(of: .metaFont)
        )
    }
}

// MARK: - ParagraphStyle

public struct ParagraphStyle: IBDecodable, AttributeProtocol {

    public let key: String?
    public let alignment: String?
    public let lineBreakMode: String?
    public let baseWritingDirection: String?
    public let tighteningFactorForTruncation: String?
    public let allowsDefaultTighteningForTruncation: Bool?

    static func decode(_ xml: XMLIndexerType) throws -> ParagraphStyle {
        let container = xml.container(keys: CodingKeys.self)
        return ParagraphStyle(
            key:                                   container.attributeIfPresent(of: .key),
            alignment:                             container.attributeIfPresent(of: .alignment),
            lineBreakMode:                         container.attributeIfPresent(of: .lineBreakMode),
            baseWritingDirection:                  container.attributeIfPresent(of: .baseWritingDirection),
            tighteningFactorForTruncation:         container.attributeIfPresent(of: .tighteningFactorForTruncation),
            allowsDefaultTighteningForTruncation:  container.attributeIfPresent(of: .allowsDefaultTighteningForTruncation)
        )
    }
}
