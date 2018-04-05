//
//  TabBar.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct TabBar: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITabBar"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let items: [TabBarItem]?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?

    public struct TabBarItem: XMLDecodable {
        public let id: String
        public let style: String?
        public let systemItem: String?
        public let title: String?

        static func decode(_ xml: XMLIndexer) throws -> TabBar.TabBarItem {
            return TabBarItem(
                id:         try xml.attributeValue(of: "id"),
                style:      xml.attributeValue(of: "style"),
                systemItem: xml.attributeValue(of: "systemItem"),
                title:      xml.attributeValue(of: "title")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> TabBar {
        return TabBar(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            items:                                     xml.byKey("items")?.byKey("tabBarItem")?.all.flatMap(decodeValue),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.byKey("userDefinedRuntimeAttribute")?.all.flatMap(decodeValue)
        )
    }
}
