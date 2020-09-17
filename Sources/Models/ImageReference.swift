//
//  ImageReference.swift
//  
//
//  Created by phimage on 17/09/2020.
//

import Foundation
import SWXMLHash

public struct ImageReference: IBDecodable, IBKeyable {

    public let key: String?
    public let image: String
    public let catalog: String?
    public let symbolScale: String?
    public let renderingMode: String?

    static func decode(_ xml: XMLIndexerType) throws -> ImageReference {
        let container = xml.container(keys: CodingKeys.self)
        return ImageReference(
            key:           container.attributeIfPresent(of: .key),
            image:         try container.attribute(of: .image),
            catalog:       container.attributeIfPresent(of: .catalog),
            symbolScale:   container.attributeIfPresent(of: .symbolScale),
            renderingMode: container.attributeIfPresent(of: .renderingMode))
    }
}
