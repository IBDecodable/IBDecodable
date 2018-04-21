//
//  Button.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Button: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIButton"

    public let autoresizingMask: AutoresizingMask?
    public let buttonType: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let fontDescription: FontDescription?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let state: [State]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    public struct State: XMLDecodable {
        public let key: String
        public let title: String
        public let color: Color?

        static func decode(_ xml: XMLIndexer) throws -> Button.State {
            return State.init(
                key:   try xml.attributeValue(of: "key"),
                title: try xml.attributeValue(of: "title"),
                color: xml.byKey("color").flatMap(decodeValue)
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Button {
        return Button(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            buttonType:                                xml.attributeValue(of: "buttonType"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            fontDescription:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            state:                                     xml.byKey("state")?.all.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.flatMap(decodeValue)
        )
    }
}
