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

    static func decode(_ xml: XMLIndexer) throws -> Self
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) throws -> T {
    return try T.decode(xml)
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) -> T? {
    return try? T.decode(xml)
}

protocol KeyDecodable: Encodable {
}
