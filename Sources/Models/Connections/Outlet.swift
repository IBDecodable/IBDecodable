//
//  Outlet.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct Outlet: XMLDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let property: String

    static func decode(_ xml: XMLIndexer) throws -> Outlet {
        return Outlet(
            id:            try xml.attributeValue(of: "id"),
            destination:   try xml.attributeValue(of: "destination"),
            property:      try xml.attributeValue(of: "property"))
    }
}
