//
//  UserDefinedRuntimeAttribute.swift
//  IBDecodable
//
//  Created by phimage on 02/04/2018.
//

import SWXMLHash

public struct UserDefinedRuntimeAttribute: XMLDecodable {
    public let keyPath: String
    public let type: String
    public let value: Any?

    static func decode(_ xml: XMLIndexer) throws -> UserDefinedRuntimeAttribute {
        let type: String = try xml.attributeValue(of: "type")
        let valueString: String? = xml.attributeValue(of: "value")
        var value: Any? = nil
        switch type {
        case "boolean":
            value = ((valueString ?? "") == "YES")
        case "color":
            let color: Color? = xml.byKey("color").flatMap(decodeValue)
            value = color
        case "number":
            if let integer: XMLIndexer = xml.byKey("integer") {
                value = Int(try integer.attributeValue(of: "value") as String)
            } else  if let real: XMLIndexer = xml.byKey("real") {
                value = Double(try real.attributeValue(of: "value") as String)
            }
        case "rect":
            let rect: Rect? = xml.byKey("rect").flatMap(decodeValue)
            value = rect
        case "point":
            let point: Point? = xml.byKey("point").flatMap(decodeValue)
            value = point
        case "range":
            let range: Range? = xml.byKey("range").flatMap(decodeValue)
            value = range
        case "nil":
            value = nil
        default:
            value = valueString
        }
        return UserDefinedRuntimeAttribute(
            keyPath:     try xml.attributeValue(of: "keyPath"),
            type:        type,
            value:       value
        )
    }

}

// MARK: - Range

public struct Range: XMLDecodable {
    public let location: Float
    public let length: Float

    static func decode(_ xml: XMLIndexer) throws -> Range {
        return Range(
            location:      try xml.attributeValue(of: "location"),
            length:        try xml.attributeValue(of: "length")
        )
    }
}
