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

public struct AnyConnection: XMLDecodable, KeyDecodable {

    public let connection: ConnectionProtocol

    init(_ connection: ConnectionProtocol) {
        self.connection = connection
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexer) throws -> AnyConnection {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "outlet":           return try AnyConnection(Outlet.decode(xml))
        case "segue":            return try AnyConnection(Segue.decode(xml))
        case "action":           return try AnyConnection(Action.decode(xml))
        case "outletCollection": return try AnyConnection(OutletCollection.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

}
