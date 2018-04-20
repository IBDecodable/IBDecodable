//
//  Action.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/20.
//

import SWXMLHash

public struct Action: XMLDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let selector: String
    public let eventType: String?

    static func decode(_ xml: XMLIndexer) throws -> Action {
        return Action(
            id:          try xml.attributeValue(of: "id"),
            destination: try xml.attributeValue(of: "destination"),
            selector:    try xml.attributeValue(of: "selector"),
            eventType:   xml.attributeValue(of: "eventType")
        )
    }
}
