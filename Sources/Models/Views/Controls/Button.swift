//
//  Button.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Button: XMLDecodable, KeyDecodable, ViewProtocol {
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

    public struct State: XMLDecodable, KeyDecodable {
        public let key: String
        public let title: String
        public let color: Color?

        static func decode(_ xml: XMLIndexer) throws -> Button.State {
            let container = xml.container(keys: CodingKeys.self)
            return State.init(
                key:   try container.attribute(of: .key),
                title: try container.attribute(of: .title),
                color: xml.byKey("color").flatMap(decodeValue)
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Button {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return Button(
            id:                                        try container.attribute(of: .id),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            buttonType:                                container.attributeIfPresent(of: .buttonType),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                  container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            fontDescription:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            lineBreakMode:                             container.attributeIfPresent(of: .lineBreakMode),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            state:                                     xml.byKey("state")?.all.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.flatMap(decodeValue)
        )
    }
}
