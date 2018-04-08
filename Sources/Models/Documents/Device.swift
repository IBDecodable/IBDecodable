//
//  Device.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct Device: XMLDecodable {

    public let id: String
    public let orientation: String?
    public let adaptation: String?

    static func decode(_ xml: XMLIndexer) throws -> Device {
        return Device(
            id:          try xml.attributeValue(of: "id"),
            orientation: xml.attributeValue(of: "orientation"),
            adaptation:  xml.byKey("adaptation")?.attributeValue(of: "id")
        )
    }
}
