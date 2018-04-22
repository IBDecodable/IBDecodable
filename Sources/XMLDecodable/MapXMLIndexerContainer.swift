//
//  MapXMLIndexerContainer.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/22.
//

import Foundation
import SWXMLHash

class MapXMLIndexerContainer<From, Parent>: XMLIndexerContainerType where Parent: XMLIndexerContainerType {

    typealias To = Parent.Key
    typealias Transformer = (From) -> To

    private let parent: Parent
    private let transformer: Transformer

    init(parent: Parent, transformer: @escaping Transformer) {
        self.parent = parent
        self.transformer = transformer
    }

    func attribute<T>(of key: From) throws -> T where T: XMLAttributeDecodable {
        return try parent.attribute(of: transformer(key))
    }
    func attributeIfPresent<T>(of key: From) -> T? where T: XMLAttributeDecodable {
        return parent.attributeIfPresent(of: transformer(key))
    }
    func element<T>(of key: From) throws -> T where T: XMLDecodable {
        return try parent.element(of: transformer(key))
    }
    func elementIfPresent<T>(of key: From) -> T? where T: XMLDecodable {
        return parent.elementIfPresent(of: transformer(key))
    }
    func elements<T>(of key: From) throws -> [T] where T: XMLDecodable {
        return try parent.elements(of: transformer(key))
    }
    func elementsIfPresent<T>(of key: From) -> [T]? where T: XMLDecodable {
        return parent.elementsIfPresent(of: transformer(key))
    }
    func children<T>(of key: From) throws -> [T] where T: XMLDecodable {
        return try parent.children(of: transformer(key))
    }
    func childrenIfPresent<T>(of key: From) -> [T]? where T: XMLDecodable {
        return parent.childrenIfPresent(of: transformer(key))
    }
    func withAttributeElements<T>(_ attr: From, _ value: String) -> [T]? where T : XMLDecodable {
        return parent.withAttributeElements(transformer(attr), value)
    }
    func withAttributeElement<T>(_ attr: From, _ value: String) -> T? where T : XMLDecodable {
        return parent.withAttributeElement(transformer(attr), value)
    }
    func nestedContainer<A>(of key: From, keys: A.Type) throws -> XMLIndexerContainer<A> {
        return try parent.nestedContainer(of: transformer(key), keys: A.self)
    }
    func nestedContainerIfPresent<A>(of key: From, keys: A.Type) -> XMLIndexerContainer<A>? {
        return parent.nestedContainerIfPresent(of: transformer(key), keys: A.self)
    }
    func nestedContainers<A>(of key: From, keys: A.Type) throws -> [XMLIndexerContainer<A>] {
        return try parent.nestedContainers(of: transformer(key), keys: A.self)
    }
}

extension XMLIndexerContainer {

    func map<T>(_ transformer: @escaping (T) -> K) -> MapXMLIndexerContainer<T, XMLIndexerContainer> {
        return MapXMLIndexerContainer(parent: self, transformer: transformer)
    }
}
