//
//  String.swift
//  
//
//  Created by Ibrahim Hassan on 05/02/21.
//

import SWXMLHash

//<rect key="frame" x="0.0" y="0.0" width="320" height="284"/>
//<string key="text">Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.</string>

public struct StringContainer: XMLAttributeDecodable, IBDecodable {
    static func decode(_ xml: XMLIndexerType) throws -> StringContainer {
        return StringContainer(stringValue: xml.elementText)
    }
    
    static func decode(_ attribute: XMLAttribute) throws -> StringContainer {
        return StringContainer(stringValue: attribute.text)
    }
    
    public let stringValue: String?
}
