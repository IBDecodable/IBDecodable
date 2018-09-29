//
//  SearchDisplayController.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public struct SearchDisplayController: IBDecodable, IBIdentifiable {

    public let elementClass: String = "UISearchDisplayController" // deprecated
    public let id: String
    public let connections: [AnyConnection]?

    static func decode(_ xml: XMLIndexerType) throws -> SearchDisplayController {
        let container = xml.container(keys: CodingKeys.self)
        return SearchDisplayController(
            id:                   try container.attribute(of: .id),
            connections:          container.childrenIfPresent(of: .connections)
        )
    }
}
