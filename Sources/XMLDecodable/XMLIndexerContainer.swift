//
//  XMLIndexerContainer.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/22.
//

import SWXMLHash

protocol XMLIndexerContainerType {

    associatedtype Key

    func attribute<T>(of key: Key) throws -> T where T: XMLAttributeDecodable
    func attributeIfPresent<T>(of key: Key) -> T? where T: XMLAttributeDecodable
    func element<T>(of key: Key) throws -> T where T: XMLDecodable
    func elementIfPresent<T>(of key: Key) -> T? where T: XMLDecodable
    func elements<T>(of key: Key) throws -> [T] where T: XMLDecodable
    func elementsIfPresent<T>(of key: Key) -> [T]? where T: XMLDecodable
    func children<T>(of key: Key) throws -> [T] where T: XMLDecodable
    func childrenIfPresent<T>(of key: Key) -> [T]? where T: XMLDecodable
    func withAttributeElements<T>(_ attr: Key, _ value: String) -> [T]? where T: XMLDecodable
    func withAttributeElement<T>(_ attr: Key, _ value: String) -> T? where T: XMLDecodable
    func nestedContainer<A>(of key: Key, keys: A.Type) throws -> XMLIndexerContainer<A>
    func nestedContainerIfPresent<A>(of key: Key, keys: A.Type) -> XMLIndexerContainer<A>?
    func nestedContainers<A>(of key: Key, keys: A.Type) throws -> [XMLIndexerContainer<A>]
}

class XMLIndexerContainer<K>: XMLIndexerContainerType where K: CodingKey {

    let indexer: XMLIndexerType

    fileprivate init(indexer: XMLIndexerType) {
        self.indexer = indexer
    }

    func attribute<T>(of key: K) throws -> T where T: XMLAttributeDecodable {
        return try indexer.attributeValue(of: key.stringValue)
    }

    func attributeIfPresent<T>(of key: K) -> T? where T: XMLAttributeDecodable {
        return try? attribute(of: key)
    }

    func element<T>(of key: K) throws -> T where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return try decodeValue(nestedIndexer)
    }

    func elementIfPresent<T>(of key: K) -> T? where T: XMLDecodable {
        return try? element(of: key)
    }

    func elements<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return try nestedIndexer.allElements.map(decodeValue)
    }

    func elementsIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        return try? elements(of: key)
    }

    func children<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return try nestedIndexer.childrenElements.map(decodeValue)
    }

    func childrenIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType? = indexer.byKey(key.stringValue)
        return nestedIndexer?.childrenElements.compactMap(decodeValue)
    }

    func withAttributeElements<T>(_ attr: K, _ value: String) -> [T]? where T : XMLDecodable {
        let elements: [XMLIndexerType]? = indexer.withAttribute(attr.stringValue, value)?.allElements
        return elements?.compactMap(decodeValue)
    }

    func withAttributeElement<T>(_ attr: K, _ value: String) -> T? where T : XMLDecodable {
        let element: XMLIndexerType? = indexer.withAttribute(attr.stringValue, value)
        return element.flatMap(decodeValue)
    }

    func nestedContainer<A>(of key: K, keys: A.Type) throws -> XMLIndexerContainer<A> {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return XMLIndexerContainer<A>.init(indexer: nestedIndexer)
    }

    func nestedContainerIfPresent<A>(of key: K, keys: A.Type) -> XMLIndexerContainer<A>? {
        return try? nestedContainer(of: key, keys: keys)
    }

    func nestedContainers<A>(of key: K, keys: A.Type) throws -> [XMLIndexerContainer<A>] {
        let nestedIndexers: [XMLIndexerType] = try indexer.byKey(key.stringValue).allElements
        return nestedIndexers.map(XMLIndexerContainer<A>.init)
    }
}

extension XMLIndexer: XMLIndexerType {
    var childrenElements: [XMLIndexerType] {
        return children
    }

    var allElements: [XMLIndexerType] {
        return all
    }

    func byKey(_ key: String) throws -> XMLIndexerType {
        return try byKey(key) as XMLIndexer
    }

    func byKey(_ key: String) -> XMLIndexerType? {
        return byKey(key) as XMLIndexer?
    }

    func withAttribute(_ attr: String, _ value: String) throws -> XMLIndexerType {
        return try withAttribute(attr, value) as XMLIndexer
    }

    func withAttribute(_ attr: String, _ value: String) -> XMLIndexerType? {
        return withAttribute(attr, value) as XMLIndexer?
    }

    var elementName: String? { return element?.name }
    var elementText: String? { return element?.text }
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K> {
        return XMLIndexerContainer.init(indexer: self)
    }
}
