//
//  Outlet.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct Outlet: IBDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let property: String

    static func decode(_ xml: XMLIndexer) throws -> Outlet {
        let container = xml.container(keys: CodingKeys.self)
        return Outlet(
            id:            try container.attribute(of: .id),
            destination:   try container.attribute(of: .destination),
            property:      try container.attribute(of: .property))
    }
}
