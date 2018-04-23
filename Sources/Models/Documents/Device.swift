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

    enum AdaptationCodingKeys: CodingKey {
        case id
    }

    static func decode(_ xml: XMLIndexer) throws -> Device {
        let container = xml.container(keys: CodingKeys.self)
        let adaptationContainer = container.nestedContainerIfPresent(of: .adaptation, keys: AdaptationCodingKeys.self)
        return Device(
            id:          try container.attribute(of: .id),
            orientation: container.attributeIfPresent(of: .orientation),
            adaptation:  adaptationContainer?.attributeIfPresent(of: .id)
        )
    }
}
