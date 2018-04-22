//
//  Device.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct Device: XMLDecodable, KeyDecodable {

    public let id: String
    public let orientation: String?
    public let adaptation: String?

    static func decode(_ xml: XMLIndexer) throws -> Device {
        let container = xml.container(keys: CodingKeys.self)
        return Device(
            id:          try container.attribute(of: .id),
            orientation: container.attributeIfPresent(of: .orientation),
            adaptation:  xml.byKey("adaptation")?.attributeValue(of: "id")
        )
    }
}
