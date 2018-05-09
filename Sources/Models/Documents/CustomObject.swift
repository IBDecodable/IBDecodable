//
//  CustomObject.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public struct CustomObject: IBDecodable, IBIdentifiable {

    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?

    static func decode(_ xml: XMLIndexer) throws -> CustomObject {
        let container = xml.container(keys: CodingKeys.self)
        return CustomObject(
            id:                    try container.attribute(of: .id),
            customClass:           container.attributeIfPresent(of: .customClass),
            customModule:          container.attributeIfPresent(of: .customModule),
            customModuleProvider:  container.attributeIfPresent(of: .customModuleProvider)
        )
    }

}
