//
//  XMLDecodable.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/22.
//

import SWXMLHash
import Foundation

protocol XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self
}

protocol XMLDecodable {

    static func decode(_ xml: XMLIndexerType) throws -> Self
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexerType) throws -> T {
    return try T.decode(xml)
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexerType) -> T? {
    return try? T.decode(xml)
}

protocol KeyDecodable: Encodable {
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
