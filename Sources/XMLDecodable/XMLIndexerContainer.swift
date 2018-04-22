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
    func nestedContainer<A>(of key: Key, keys: A.Type) throws -> XMLIndexerContainer<A>
    func nestedContainerIfPresent<A>(of key: Key, keys: A.Type) -> XMLIndexerContainer<A>?
    func nestedContainers<A>(of key: Key, keys: A.Type) throws -> [XMLIndexerContainer<A>]
}

class XMLIndexerContainer<K>: XMLIndexerContainerType where K: CodingKey {

    private let indexer: XMLIndexer

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    func attribute<T>(of key: K) throws -> T where T: XMLAttributeDecodable {
        return try indexer.attributeValue(of: key.stringValue)
    }

    func attributeIfPresent<T>(of key: K) -> T? where T: XMLAttributeDecodable {
        return try? attribute(of: key)
    }

    func element<T>(of key: K) throws -> T where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try decodeValue(nestedIndexer)
    }

    func elementIfPresent<T>(of key: K) -> T? where T: XMLDecodable {
        return try? element(of: key)
    }

    func elements<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try nestedIndexer.all.map(decodeValue)
    }

    func elementsIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        return try? elements(of: key)
    }

    func children<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try nestedIndexer.children.map(decodeValue)
    }

    func childrenIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        let nestedIndexer: XMLIndexer? = indexer.byKey(key.stringValue)
        return nestedIndexer?.children.compactMap(decodeValue)
    }

    func nestedContainer<A>(of key: K, keys: A.Type) throws -> XMLIndexerContainer<A> {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return XMLIndexerContainer<A>.init(indexer: nestedIndexer)
    }

    func nestedContainerIfPresent<A>(of key: K, keys: A.Type) -> XMLIndexerContainer<A>? {
        return try? nestedContainer(of: key, keys: keys)
    }

    func nestedContainers<A>(of key: K, keys: A.Type) throws -> [XMLIndexerContainer<A>] {
        let nestedIndexers: [XMLIndexer] = try indexer.byKey(key.stringValue).all
        return nestedIndexers.map(XMLIndexerContainer<A>.init)
    }
}

extension XMLIndexer {
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K> {
        return XMLIndexerContainer.init(indexer: self)
    }
}
