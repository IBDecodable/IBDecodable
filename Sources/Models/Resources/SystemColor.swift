//
//  SystemColor.swift
//  IBDecodable
//  
//
//  Created by phimage on 17/09/2020.
//

import Foundation
import SWXMLHash

public struct SystemColor: IBDecodable, ResourceProtocol {
    public let name: String
    public let color: Color?

    static func decode(_ xml: XMLIndexerType) throws -> SystemColor {
        let container = xml.container(keys: CodingKeys.self)
        return SystemColor(
            name:    try container.attribute(of: .name),
            color:   container.elementIfPresent(of: .color))
    }

}
