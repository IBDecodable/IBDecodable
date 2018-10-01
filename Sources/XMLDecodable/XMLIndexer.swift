//
//  XMLIndexer.swift
//  IBDecodable
//
//  Created by Yuta Saito on 2018/09/29.
//

protocol XMLIndexerType {
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K>
    func byKey(_ key: String) throws -> XMLIndexerType
    func byKey(_ key: String) -> XMLIndexerType?
    func attributeValue<T: XMLAttributeDecodable>(of attr: String) -> T?
    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T
    func withAttribute(_ attr: String, _ value: String) throws -> XMLIndexerType
    func withAttribute(_ attr: String, _ value: String) -> XMLIndexerType?

    var elementName: String? { get }
    var elementText: String? { get }
    var childrenElements: [XMLIndexerType] { get }
    var allElements: [XMLIndexerType] { get }
}
