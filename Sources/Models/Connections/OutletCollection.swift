//
//  OutletCollection.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/20.
//

import SWXMLHash

public struct OutletCollection: XMLDecodable, KeyDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let property: String
    public let collectionClass: String?
    public let appends: Bool?

    static func decode(_ xml: XMLIndexer) throws -> OutletCollection {
        let container = xml.container(keys: CodingKeys.self)
        return OutletCollection(
            id:              try container.attribute(of: .id),
            destination:     try container.attribute(of: .destination),
            property:        try container.attribute(of: .property),
            collectionClass: container.attributeIfPresent(of: .collectionClass),
            appends:         container.attributeIfPresent(of: .appends)
        )
    }
}
