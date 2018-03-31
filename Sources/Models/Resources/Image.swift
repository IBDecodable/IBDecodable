//
//  Image.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct Image: XMLDecodable, ResourceProtocol {
    public let name: String
    public let width: String
    public let height: String
    
    static func decode(_ xml: XMLIndexer) throws -> Image {
        return Image.init(
            name:      try xml.attributeValue(of: "name"),
            width:     try xml.attributeValue(of: "width"),
            height:    try xml.attributeValue(of: "height"))
    }
}