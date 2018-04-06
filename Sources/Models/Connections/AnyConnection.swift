//
//  AnyConnection.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

// MARK: - ConnectionProtocol

public protocol ConnectionProtocol {
    var id: String { get }
    var destination: String { get }
}

// MARK: - AnyConnection

public struct AnyConnection: XMLDecodable {

    public let connection: ConnectionProtocol

    init(_ connection: ConnectionProtocol) {
        self.connection = connection
    }

    static func decode(_ xml: XMLIndexer) throws -> AnyConnection {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "outlet":      return try AnyConnection(Outlet.decode(xml))
        case "segue":           return try AnyConnection(Segue.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

}
