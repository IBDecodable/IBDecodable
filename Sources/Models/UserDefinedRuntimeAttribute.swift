//
//  UserDefinedRuntimeAttribute.swift
//  IBDecodable
//
//  Created by phimage on 02/04/2018.
//

import SWXMLHash

public struct UserDefinedRuntimeAttribute: IBDecodable {
    public let keyPath: String
    public let type: String
    public let value: Any?

    public func encode(to encoder: Encoder) throws { fatalError() }

    enum CodingKeys: CodingKey {
        case type
        case keyPath
        case value
    }

    static func decode(_ xml: XMLIndexer) throws -> UserDefinedRuntimeAttribute {
        let container = xml.container(keys: CodingKeys.self)
        let type: String = try container.attribute(of: .type)
        let valueString: String? = container.attributeIfPresent(of: .value)
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
            keyPath:     try container.attribute(of: .keyPath),
            type:        type,
            value:       value
        )
    }

    public static func == (left: UserDefinedRuntimeAttribute, right: UserDefinedRuntimeAttribute) -> Bool {
        guard left.keyPath == right.keyPath, left.type == right.type else {
            return false
        }
        return true
    }
}

// MARK: - Range

public struct Range: IBDecodable {
    public let location: Float
    public let length: Float

    static func decode(_ xml: XMLIndexer) throws -> Range {
        let container = xml.container(keys: CodingKeys.self)
        return Range(
            location:      try container.attribute(of: .location),
            length:        try container.attribute(of: .length)
        )
    }
}
