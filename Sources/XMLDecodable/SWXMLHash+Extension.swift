//
//  SWXMLHash+Extension.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/14.
//

import SWXMLHash
import Foundation

extension XMLIndexer {

    func attributeValue<T: XMLAttributeDecodable>(of attr: String) -> T? {
        return try? attributeValue(of: attr)
    }

    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T {
        switch self {
        case .element(let element):
            guard let attribute = element.attribute(by: attr) else { throw XMLDeserializationError.nodeHasNoValue }
            let value = try T.decode(attribute)
            element.allAttributes.removeValue(forKey: attr)
            return value
        default: throw XMLDeserializationError.implementationIsMissing(method: "attributeValue for stream case")
        }
    }

    public func byKey(_ key: String) -> XMLIndexer? {
        return try? byKey(key)
    }

    public func withAttribute(_ attr: String, _ value: String) -> XMLIndexer? {
        return try? withAttribute(attr, value)
    }

}

extension XMLAttributeDeserializable where Self: XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self {
        return try deserialize(attribute)
    }
}

extension String: XMLAttributeDecodable {}
extension Int: XMLAttributeDecodable {}
extension Float: XMLAttributeDecodable {}
extension Bool: XMLAttributeDecodable {}
extension Double: XMLAttributeDecodable {}
