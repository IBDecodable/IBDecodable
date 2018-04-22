//
//  XibDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct XibDocument: XMLDecodable, KeyDecodable {
    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: String
    public let propertyAccessControl: String?
    public let useAutolayout: Bool?
    public let useTraitCollections: Bool?
    public let useSafeAreas: Bool?
    public let colorMatched: Bool?
    public let device: Device?
    public let views: [AnyView]?
    public let placeholders: [Placeholder]?
    public let connections: [AnyConnection]?

    static func decode(_ xml: XMLIndexer) throws -> XibDocument {
        let container = xml.container(keys: CodingKeys.self)
        return XibDocument(
            type:                  try container.attribute(of: .type),
            version:               try container.attribute(of: .version),
            toolsVersion:          try container.attribute(of: .toolsVersion),
            targetRuntime:         try container.attribute(of: .targetRuntime),
            propertyAccessControl: container.attributeIfPresent(of: .propertyAccessControl),
            useAutolayout:         container.attributeIfPresent(of: .useAutolayout),
            useTraitCollections:   container.attributeIfPresent(of: .useTraitCollections),
            useSafeAreas:          container.attributeIfPresent(of: .useSafeAreas),
            colorMatched:          container.attributeIfPresent(of: .colorMatched),
            device:                container.elementIfPresent(of: .device),
            views:                 xml.byKey("objects")?.children.flatMap(decodeValue),
            placeholders:          xml.byKey("objects")?.byKey("placeholder")?.all.flatMap(decodeValue),
            connections:           findConnections(in: xml)
        )
    }
}
