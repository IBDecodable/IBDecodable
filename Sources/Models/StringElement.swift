//
//  StringElement.swift
//  
//
//  Created by Kostas Antonopoulos on 14/6/21.
//

import Foundation

public struct StringElement: IBDecodable, IBKeyable {
        
    public let key: String?
    public let elementValue: String?
    
    static func decode(_ xml: XMLIndexerType) throws -> StringElement {
        let container = xml.container(keys: CodingKeys.self)
        
        return StringElement(
            key: container.attributeIfPresent(of: .key),
            elementValue: xml.elementText)
    }
}
