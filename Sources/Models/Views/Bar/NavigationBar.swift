//
//  NavigationBar.swift
//  IBDecodable
//
//  Created by phimage on 02/04/2018.
//

import SWXMLHash

public struct NavigationBar: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UINavigationBar"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let items: [NavigationItem]?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    public struct NavigationItem: XMLDecodable {
        public let id: String
        public let style: String?
        public let systemItem: String?
        public let title: String?

        static func decode(_ xml: XMLIndexer) throws -> NavigationBar.NavigationItem {
            return NavigationItem(
                id:         try xml.attributeValue(of: "id"),
                style:      xml.attributeValue(of: "style"),
                systemItem: xml.attributeValue(of: "systemItem"),
                title:      xml.attributeValue(of: "title")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> NavigationBar {
        return NavigationBar(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            items:                                     xml.byKey("items")?.byKey("navigationItem")?.all.flatMap(decodeValue),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.flatMap(decodeValue)
        )
    }
}
