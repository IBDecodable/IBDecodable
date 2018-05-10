//
//  Accessibility.swift
//  IBDecodable
//
//  Created by phimage on 10/05/2018.
//

import SWXMLHash

// MARK: - Accessibility

public struct Accessibility: IBDecodable, IBKeyable {

    public let key: String?
    public let traits: AccessibilityTraits?
    public let isElement: IBBool?

    enum ExternalCodingKeys: CodingKey { case accessibilityTraits, bool }
    enum AttributedStringCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexer) throws -> Accessibility {
        let container = xml.container(keys: CodingKeys.self)
        let accessibilityTraitsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .accessibilityTraits, keys: AttributedStringCodingKeys.self)
        let boolContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .bool, keys: AttributedStringCodingKeys.self)
        return Accessibility(
            key: container.attributeIfPresent(of: .key),
            traits: accessibilityTraitsContainer?.withAttributeElement(.key, CodingKeys.traits.stringValue),
            isElement: boolContainer?.withAttributeElement(.key, CodingKeys.isElement.stringValue)
        )
    }

}

// MARK: - AccessibilityTraits

public struct AccessibilityTraits: IBDecodable, IBKeyable {

    public let key: String?
    public let button: Bool
    public let link: Bool
    public let playsSound: Bool
    public let staticText: Bool
    public let header: Bool

    static func decode(_ xml: XMLIndexer) throws -> AccessibilityTraits {
        let container = xml.container(keys: CodingKeys.self)
        return AccessibilityTraits(
            key: container.attributeIfPresent(of: .key),
            button: container.attributeIfPresent(of: .button) ?? false,
            link: container.attributeIfPresent(of: .link) ?? false,
            playsSound: container.attributeIfPresent(of: .playsSound) ?? false,
            staticText: container.attributeIfPresent(of: .staticText) ?? false,
            header: container.attributeIfPresent(of: .header) ?? false
        )
    }

}

// MARK: - Bool

public struct IBBool: IBDecodable, IBKeyable {

    public let key: String?
    public let value: Bool

    static func decode(_ xml: XMLIndexer) throws -> IBBool {
        let container = xml.container(keys: CodingKeys.self)
        return IBBool(
            key:   container.attributeIfPresent(of: .key),
            value: container.attributeIfPresent(of: .value) ?? false
        )
    }

}
