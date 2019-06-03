//
//  XMLIndexer.swift
//  IBDecodable
//
//  Created by Yuta Saito on 2018/09/29.
//

import SWXMLHash

protocol XMLIndexerType {
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K>
    func byKey(_ key: String) throws -> XMLIndexerType
    func byKeyIfPresent(_ key: String) -> XMLIndexerType?
    func withAttribute(_ attr: String, _ value: String) throws -> XMLIndexerType
    func withAttributeIfPresent(_ attr: String, _ value: String) -> XMLIndexerType?
    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T

    var elementName: String? { get }
    var elementText: String? { get }
    var childrenElements: [XMLIndexerType] { get }
    var allElements: [XMLIndexerType] { get }
}

extension XMLIndexer: XMLIndexerType {

    var elementName: String? {
        return element?.name
    }

    var elementText: String? {
        return element?.text
    }

    var childrenElements: [XMLIndexerType] {
        return children
    }

    var allElements: [XMLIndexerType] {
        return all
    }

    func byKey(_ key: String) throws -> XMLIndexerType {
        return try byKey(key) as XMLIndexer
    }

    func byKeyIfPresent(_ key: String) -> XMLIndexerType? {
        return try? (byKey(key) as XMLIndexer)
    }

    func withAttribute(_ attr: String, _ value: String) throws -> XMLIndexerType {
        return try withAttribute(attr, value) as XMLIndexer
    }

    func withAttributeIfPresent(_ attr: String, _ value: String) -> XMLIndexerType? {
        return try? (withAttribute(attr, value) as XMLIndexer)
    }

    func container<K>(keys: K.Type) -> XMLIndexerContainer<K> {
        return XMLIndexerContainer.init(indexer: self)
    }

    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T {
        switch self {
        case .element(let element):
            guard let attr = element.attribute(by: attr) else { throw XMLDeserializationError.nodeHasNoValue }
            return try T.decode(attr)
        default: throw XMLDeserializationError.implementationIsMissing(method: "attributeValue for stream case")
        }
    }

}
