//
//  Classes.swift
//  IBDecodable
//
//  Created by phimage on 12/05/2018.
//

import SWXMLHash

// MARK: - IBClass

public struct IBClass: IBDecodable {

    public let className: String?
    public let superclassName: String?
    public let source: Source?
    public let relationships: [Relationship]?

    static func decode(_ xml: XMLIndexer) throws -> IBClass {
        let container = xml.container(keys: CodingKeys.self)
        return IBClass(
            className:      container.attributeIfPresent(of: .className),
            superclassName: container.attributeIfPresent(of: .superclassName),
            source:         container.elementIfPresent(of: .source),
            relationships:  container.childrenIfPresent(of: .relationships)
        )
    }

}

// MARK: - Source

public struct Source: IBDecodable, IBKeyable {

    public let key: String?
    public let type: String?
    public let relativePath: String?

    static func decode(_ xml: XMLIndexer) throws -> Source {
        let container = xml.container(keys: CodingKeys.self)
        return Source(
            key:          container.attributeIfPresent(of: .key),
            type:         container.attributeIfPresent(of: .type),
            relativePath: container.attributeIfPresent(of: .relativePath)
        )
    }

}

// MARK: - Relationship

public struct Relationship: IBDecodable {
    
    public let kind: String?
    public let name: String?
    
    static func decode(_ xml: XMLIndexer) throws -> Relationship {
        let container = xml.container(keys: CodingKeys.self)
        return Relationship(
            kind: container.attributeIfPresent(of: .kind),
            name: container.attributeIfPresent(of: .name)
        )
    }
    
}
