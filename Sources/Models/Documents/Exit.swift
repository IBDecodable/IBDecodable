//
//  Exit.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public struct Exit: IBDecodable, IBIdentifiable {

    public let id: String
    public let userLabel: String?
    public let sceneMemberID: String?

    static func decode(_ xml: XMLIndexer) throws -> Exit {
        let container = xml.container(keys: CodingKeys.self)
        return Exit(
            id:            try container.attribute(of: .id),
            userLabel:     container.attributeIfPresent(of: .userLabel),
            sceneMemberID: container.attributeIfPresent(of: .sceneMemberID)
        )
    }

}
