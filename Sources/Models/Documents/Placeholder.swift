//
//  Placeholder.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct Placeholder: IBDecodable, IBIdentifiable, IBCustomClassable, IBUserLabelable {

    public let id: String
    public let placeholderIdentifier: String
    public let userLabel: String?
    public let colorLabel: String?
    public let sceneMemberID: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userComments: AttributedString?

    enum ExternalCodingKeys: CodingKey { case attributedString }
    enum AttributedStringCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> Placeholder {
        let container = xml.container(keys: CodingKeys.self)
        let attributedStringContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .attributedString, keys: AttributedStringCodingKeys.self)
        return Placeholder(
            id:                    try container.attribute(of: .id),
            placeholderIdentifier: try container.attribute(of: .placeholderIdentifier),
            userLabel:             container.attributeIfPresent(of: .userLabel),
            colorLabel:            container.attributeIfPresent(of: .colorLabel),
            sceneMemberID:         container.attributeIfPresent(of: .sceneMemberID),
            customClass:           container.attributeIfPresent(of: .customClass),
            customModule:          container.attributeIfPresent(of: .customModule),
            customModuleProvider:  container.attributeIfPresent(of: .customModuleProvider),
            userComments:          attributedStringContainer?.withAttributeElement(.key, "userComments")
        )
    }

}
