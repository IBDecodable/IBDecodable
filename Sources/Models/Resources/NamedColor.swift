//
//  NamedColor.swift
//  Tests
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct NamedColor: XMLDecodable, ResourceProtocol {
    public let name: String
    public let color: Color?

    static func decode(_ xml: XMLIndexer) throws -> NamedColor {
        return NamedColor(
            name:    try xml.attributeValue(of: "name"),
            color:   xml.byKey("color").flatMap(decodeValue))
    }

}
