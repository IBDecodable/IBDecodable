//
//  SystemColor.swift
//  IBDecodable
//
//  Created by Kostas Antonopoulos on 29/6/21.
//

import Foundation

public struct SystemColor: IBDecodable, ResourceProtocol {
    public let name: String
    public let color: Color?

    static func decode(_ xml: XMLIndexerType) throws -> SystemColor {
        let container = xml.container(keys: CodingKeys.self)
        return SystemColor(
            name:    try container.attribute(of: .name),
            color:   try! container.element(of: .color))
    }

}
