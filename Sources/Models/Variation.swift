//
//  Variation.swift
//  IBDecodable
//
//  Created by phimage on 10/05/2018.
//

import SWXMLHash

// MARK: - Variation

public struct Variation: IBDecodable, IBKeyable {

    public let key: String?
    public let mask: [Mask]?

    static func decode(_ xml: XMLIndexer) throws -> Variation {
        let container = xml.container(keys: CodingKeys.self)
        return Variation(
            key: container.attributeIfPresent(of: .key),
            mask: container.elementsIfPresent(of: .mask)
        )
    }

}

// MARK: - Mask

public struct Mask: IBDecodable, IBKeyable {

    public let key: String?
    public let includes: [Include]?
    public let excludes: [Exclude]?

    enum ListCodingKeys: CodingKey { case include, exclude }

    static func decode(_ xml: XMLIndexer) throws -> Mask {
        let container = xml.container(keys: CodingKeys.self)
        let listContainer = xml.container(keys: ListCodingKeys.self)
        return Mask(
            key: container.attributeIfPresent(of: .key),
            includes: listContainer.elementsIfPresent(of: .include),
            excludes: listContainer.elementsIfPresent(of: .exclude)
        )
    }

}

// MARK: - Exclude

public struct Exclude: IBDecodable {

    public let reference: String?

    static func decode(_ xml: XMLIndexer) throws -> Exclude {
        let container = xml.container(keys: CodingKeys.self)
        return Exclude(
            reference: container.attributeIfPresent(of: .reference)
        )
    }

}

// MARK: - Include

public struct Include: IBDecodable {

    public let reference: String?

    static func decode(_ xml: XMLIndexer) throws -> Include {
        let container = xml.container(keys: CodingKeys.self)
        return Include(
            reference: container.attributeIfPresent(of: .reference)
        )
    }

}
