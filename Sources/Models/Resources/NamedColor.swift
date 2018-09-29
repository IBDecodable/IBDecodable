//
//  NamedColor.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct NamedColor: IBDecodable, ResourceProtocol {
    public let name: String
    public let color: Color?

    static func decode(_ xml: XMLIndexerType) throws -> NamedColor {
        let container = xml.container(keys: CodingKeys.self)
        return NamedColor(
            name:    try container.attribute(of: .name),
            color:   container.elementIfPresent(of: .color))
    }

}
