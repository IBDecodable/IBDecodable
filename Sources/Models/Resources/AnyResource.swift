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

public struct AnyResource: XMLDecodable {

    public let resource: ResourceProtocol

    init(_ resource: ResourceProtocol) {
        self.resource = resource
    }

    static func decode(_ xml: XMLIndexer) throws -> AnyResource {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "namedColor":      return try AnyResource(NamedColor.decode(xml))
        case "image":           return try AnyResource(Image.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

}
