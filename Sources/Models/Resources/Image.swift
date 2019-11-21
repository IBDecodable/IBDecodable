//
//  Image.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct Image: IBDecodable, ResourceProtocol {
    public let name: String
    public let width: String
    public let height: String
    public let catalog: String?
    public let mutableData: MutableData?

    static func decode(_ xml: XMLIndexerType) throws -> Image {
        let container = xml.container(keys: CodingKeys.self)
        return Image(
            name:          try container.attribute(of: .name),
            width:         try container.attribute(of: .width),
            height:        try container.attribute(of: .height),
            catalog:       container.attributeIfPresent(of: .catalog),
            mutableData:   container.elementIfPresent(of: .mutableData))
    }
}

public struct MutableData: IBDecodable {
    public let key: String
    public let content: String?

    static func decode(_ xml: XMLIndexerType) throws -> MutableData {
        let container = xml.container(keys: CodingKeys.self)
        return MutableData(
            key:      try container.attribute(of: .key),
            content:  xml.elementText)
    }
}
