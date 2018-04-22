//
//  Placeholder.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct Placeholder: XMLDecodable, KeyDecodable {

    public let id: String
    public let placeholderIdentifier: String
    public let userLabel: String?
    public let colorLabel: String?
    public let sceneMemberID: String?
    public let customClass: String?
    public let userComments: AttributedString?

    enum AttributedStringCodingKeys: CodingKey {
        case key
    }

    static func decode(_ xml: XMLIndexer) throws -> Placeholder {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .userComments: return "attributedString"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let attributedStringContainer = container.nestedContainerIfPresent(of: .userComments, keys: AttributedStringCodingKeys.self)
        return Placeholder(
            id:                    try container.attribute(of: .id),
            placeholderIdentifier: try container.attribute(of: .placeholderIdentifier),
            userLabel:             container.attributeIfPresent(of: .userLabel),
            colorLabel:            container.attributeIfPresent(of: .colorLabel),
            sceneMemberID:         container.attributeIfPresent(of: .sceneMemberID),
            customClass:           container.attributeIfPresent(of: .customClass),
            userComments:          attributedStringContainer?.withAttributeElement(.key, "userComments")
        )
    }

}
