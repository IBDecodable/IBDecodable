//
//  Placeholder.swift
//  IBDecodable
//
//  Created by phimage on 08/04/2018.
//

import SWXMLHash

public struct Placeholder: XMLDecodable {

    public let id: String
    public let placeholderIdentifier: String
    public let userLabel: String?
    public let colorLabel: String?
    public let sceneMemberID: String?
    public let customClass: String?
    public let attributedString: AttributedString?

    static func decode(_ xml: XMLIndexer) throws -> Placeholder {
        return Placeholder(
            id:                    try xml.attributeValue(of: "id"),
            placeholderIdentifier: try xml.attributeValue(of: "placeholderIdentifier"),
            userLabel:             xml.attributeValue(of: "userLabel"),
            colorLabel:            xml.attributeValue(of: "colorLabel"),
            sceneMemberID:         xml.attributeValue(of: "sceneMemberID"),
            customClass:           xml.attributeValue(of: "customClass"),
            attributedString:      xml.byKey("attributedString").flatMap(decodeValue)
        )
    }

}
