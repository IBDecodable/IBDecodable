//
//  OutletCollection.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/20.
//

import SWXMLHash

public struct OutletCollection: XMLDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let property: String
    public let collectionClass: String?
    public let appends: Bool?

    static func decode(_ xml: XMLIndexer) throws -> OutletCollection {
        return OutletCollection(
            id:              try xml.attributeValue(of: "id"),
            destination:     try xml.attributeValue(of: "destination"),
            property:        try xml.attributeValue(of: "property"),
            collectionClass: xml.attributeValue(of: "collectionClass"),
            appends:         xml.attributeValue(of: "appends")
        )
    }
}
