//
//  Geometry.swift
//  IBDecodable
//
//  Created by phimage on 10/05/2018.
//

import SWXMLHash

// MARK: - Rect

public struct Rect: IBDecodable, IBKeyable {

    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Rect {
        let container = xml.container(keys: CodingKeys.self)
        return Rect(
            x:      try container.attribute(of: .x),
            y:      try container.attribute(of: .y),
            width:  try container.attribute(of: .width),
            height: try container.attribute(of: .height),
            key:    container.attributeIfPresent(of: .key)
        )
    }

}

// MARK: - Point

public struct Point: IBDecodable, IBKeyable {

    public let x: Float
    public let y: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Point {
        let container = xml.container(keys: CodingKeys.self)
        return Point(
            x:      try container.attribute(of: .x),
            y:      try container.attribute(of: .y),
            key:    container.attributeIfPresent(of: .key)
        )
    }

}

// MARK: - Size

public struct Size: IBDecodable, IBKeyable {

    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Size {
        let container = xml.container(keys: CodingKeys.self)
        return Size(
            width:  try container.attribute(of: .width),
            height: try container.attribute(of: .height),
            key:    container.attributeIfPresent(of: .key)
        )
    }

}

// MARK: - Inset

public struct Inset: IBDecodable, IBKeyable {

    public let minX: Float
    public let minY: Float
    public let maxX: Float
    public let maxY: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Inset {
        let container = xml.container(keys: CodingKeys.self)
        return Inset(
            minX: try container.attribute(of: .minX),
            minY: try container.attribute(of: .minY),
            maxX: try container.attribute(of: .maxX),
            maxY: try container.attribute(of: .maxY),
            key:  container.attributeIfPresent(of: .key)
        )
    }

}

// MARK: - Frame

public struct Frame: IBDecodable, IBKeyable {

    public let width: Float
    public let height: Float
    public let minX: Float
    public let minY: Float
    public let maxX: Float
    public let maxY: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Frame {
        let container = xml.container(keys: CodingKeys.self)
        return Frame(
            width:  try container.attribute(of: .width),
            height: try container.attribute(of: .height),
            minX:   try container.attribute(of: .minX),
            minY:   try container.attribute(of: .minY),
            maxX:   try container.attribute(of: .maxX),
            maxY:   try container.attribute(of: .maxY),
            key:    container.attributeIfPresent(of: .key)
        )
    }

}
