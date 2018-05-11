//
//  Primitive.swift
//  IBDecodable
//
//  Created by phimage on 11/05/2018.
//

import SWXMLHash

// MARK: - Bool

public struct IBBool: IBDecodable, IBKeyable {

    public let key: String?
    public let value: Bool

    static func decode(_ xml: XMLIndexer) throws -> IBBool {
        let container = xml.container(keys: CodingKeys.self)
        return IBBool(
            key:   container.attributeIfPresent(of: .key),
            value: container.attributeIfPresent(of: .value) ?? false
        )
    }

}

// MARK: - Real

public struct IBReal: IBDecodable, IBKeyable {

    public let key: String?
    public let value: Float?

    static func decode(_ xml: XMLIndexer) throws -> IBReal {
        let container = xml.container(keys: CodingKeys.self)
        return IBReal(
            key:   container.attributeIfPresent(of: .key),
            value: container.attributeIfPresent(of: .value)
        )
    }

}

// MARK: - Integer

public struct IBInteger: IBDecodable, IBKeyable {

    public let key: String?
    public let value: Int?

    static func decode(_ xml: XMLIndexer) throws -> IBInteger {
        let container = xml.container(keys: CodingKeys.self)
        return IBInteger(
            key:   container.attributeIfPresent(of: .key),
            value: container.attributeIfPresent(of: .value)
        )
    }

}
// MARK: - Nil

public struct IBNil: IBDecodable, IBKeyable {

    public let key: String?
    public let name: String?

    static func decode(_ xml: XMLIndexer) throws -> IBNil {
        let container = xml.container(keys: CodingKeys.self)
        return IBNil(
            key:   container.attributeIfPresent(of: .key),
            name:  container.attributeIfPresent(of: .name)
        )
    }

}

// MARK: - URL

public struct IBURL: IBDecodable, IBKeyable {

    public let key: String?
    public let string: String?

    static func decode(_ xml: XMLIndexer) throws -> IBURL {
        let container = xml.container(keys: CodingKeys.self)
        return IBURL(
            key:    container.attributeIfPresent(of: .key),
            string: container.attributeIfPresent(of: .string)
        )
    }

}

// MARK: - String

public struct IBString: IBDecodable, IBKeyable {

    public let key: String?
    public let base64UTF8: String?

    static func decode(_ xml: XMLIndexer) throws -> IBString {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .base64UTF8: return "base64-UTF8"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return IBString(
            key:        container.attributeIfPresent(of: .key),
            base64UTF8: container.attributeIfPresent(of: .base64UTF8)
        )
    }

}

// MARK: - Date

public struct IBDate: IBDecodable, IBKeyable {

    public let key: String?
    public let timeIntervalSinceReferenceDate: String?

    static func decode(_ xml: XMLIndexer) throws -> IBDate {
        let container = xml.container(keys: CodingKeys.self)
        return IBDate(
            key:                            container.attributeIfPresent(of: .key),
            timeIntervalSinceReferenceDate: container.attributeIfPresent(of: .timeIntervalSinceReferenceDate)
        )
    }

}

// MARK: - Array

public struct IBArray: IBDecodable, IBKeyable {

    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> IBArray {
        let container = xml.container(keys: CodingKeys.self)
        return IBArray(
            key: container.attributeIfPresent(of: .key)
        )
    }

}

// MARK: - Data

public struct IBData: IBDecodable, IBKeyable {

    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> IBData {
        let container = xml.container(keys: CodingKeys.self)
        return IBData(
            key: container.attributeIfPresent(of: .key)
        )
    }

}
