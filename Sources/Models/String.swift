//
//  StringContainer.swift
//  
//
//  Created by Ibrahim Hassan on 05/02/21.
//

import SWXMLHash

public struct StringContainer: XMLAttributeDecodable, IBDecodable {
    static func decode(_ xml: XMLIndexerType) throws -> StringContainer {
        return StringContainer(stringValue: xml.elementText)
    }
    
    static func decode(_ attribute: XMLAttribute) throws -> StringContainer {
        return StringContainer(stringValue: attribute.text)
    }
    
    public let stringValue: String?
}
