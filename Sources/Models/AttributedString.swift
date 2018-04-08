//
//  AttributedString.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct AttributedString: XMLDecodable {

    public let key: String
    public let fragments: [Fragment]?

    static func decode(_ xml: XMLIndexer) throws -> AttributedString {
        return AttributedString(
            key:            try xml.attributeValue(of: "key"),
            fragments:      xml.byKey("fragment")?.all.flatMap(decodeValue))
    }

    public struct Fragment: XMLDecodable {
        public let content: String
        public let attributes: [AnyAttribute]?

        static func decode(_ xml: XMLIndexer) throws -> Fragment {
            return Fragment(
                content:      try xml.attributeValue(of: "content"),
                attributes:   xml.byKey("attributes")?.children.flatMap(decodeValue))
        }
    }

}

// MARK: - AttributeProtocol

public protocol AttributeProtocol {
    var key: String? { get }
}

// MARK: - AnyAttribute

public struct AnyAttribute: XMLDecodable {

    public let attribute: AttributeProtocol

    init(_ attribute: AttributeProtocol) {
        self.attribute = attribute
    }

    static func decode(_ xml: XMLIndexer) throws -> AnyAttribute {
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

// MARK: - Font

public struct Font: XMLDecodable, AttributeProtocol {

    public let key: String?
    public let size: String?
    public let name: String?
    public let metaFont: String?

    static func decode(_ xml: XMLIndexer) throws -> Font {
        return Font(
            key:        xml.attributeValue(of: "key"),
            size:       xml.attributeValue(of: "size"),
            name:       xml.attributeValue(of: "name"),
            metaFont:   xml.attributeValue(of: "metaFont"))
    }
}

// MARK: - ParagraphStyle

public struct ParagraphStyle: XMLDecodable, AttributeProtocol {

    public let key: String?
    public let alignment: String?
    public let lineBreakMode: String?
    public let baseWritingDirection: String?
    public let tighteningFactorForTruncation: String?
    public let allowsDefaultTighteningForTruncation: Bool?

    static func decode(_ xml: XMLIndexer) throws -> ParagraphStyle {
        return ParagraphStyle(
            key:                                   xml.attributeValue(of: "key"),
            alignment:                             xml.attributeValue(of: "alignment"),
            lineBreakMode:                         xml.attributeValue(of: "lineBreakMode"),
            baseWritingDirection:                  xml.attributeValue(of: "baseWritingDirection"),
            tighteningFactorForTruncation:         xml.attributeValue(of: "tighteningFactorForTruncation"),
            allowsDefaultTighteningForTruncation:  xml.attributeValue(of: "allowsDefaultTighteningForTruncation")
        )
    }
}
