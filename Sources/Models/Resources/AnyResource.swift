//
//  AnyResources.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

// MARK: - ResourceProtocol

public protocol ResourceProtocol {
    var name: String { get }
}

// MARK: - AnyResource

public struct AnyResource: IBDecodable {

    public let resource: ResourceProtocol

    init(_ resource: ResourceProtocol) {
        self.resource = resource
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexerType) throws -> AnyResource {
        guard let elementName = xml.elementName else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "systemColor":     return try AnyResource(SystemColor.decode(xml))
        case "namedColor":      return try AnyResource(NamedColor.decode(xml))
        case "image":           return try AnyResource(Image.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

}

extension AnyResource: IBAny {
    public typealias NestedElement = ResourceProtocol
    public var nested: ResourceProtocol {
        return resource
    }
}
