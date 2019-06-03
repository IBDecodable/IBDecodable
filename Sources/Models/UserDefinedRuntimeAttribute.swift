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

    static func decode(_ xml: XMLIndexerType) throws -> UserDefinedRuntimeAttribute {
        let container = xml.container(keys: CodingKeys.self)
        let type: String = try container.attribute(of: .type)
        let valueString: String? = container.attributeIfPresent(of: .value)
        var value: Any?
        switch type {
        case "boolean":
            value = ((valueString ?? "") == "YES")
        case "color":
            let color: Color? = xml.byKeyIfPresent("color").flatMap(decodeValue)
            value = color
        case "number":
            if let integer: XMLIndexerType = xml.byKeyIfPresent("integer") {
                value = Int(try integer.attributeValue(of: "value") as String)
            } else  if let real: XMLIndexerType = xml.byKeyIfPresent("real") {
                value = Double(try real.attributeValue(of: "value") as String)
            }
        case "rect":
            let rect: Rect? = xml.byKeyIfPresent("rect").flatMap(decodeValue)
            value = rect
        case "point":
            let point: Point? = xml.byKeyIfPresent("point").flatMap(decodeValue)
            value = point
        case "range":
            let range: Range? = xml.byKeyIfPresent("range").flatMap(decodeValue)
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

    static func decode(_ xml: XMLIndexerType) throws -> Range {
        let container = xml.container(keys: CodingKeys.self)
        return Range(
            location:      try container.attribute(of: .location),
            length:        try container.attribute(of: .length)
        )
    }
}
