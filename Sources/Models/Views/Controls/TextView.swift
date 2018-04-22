//
//  TextView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TextView: XMLDecodable, KeyDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextView"

    public let autoresizingMask: AutoresizingMask?
    public let bounces: Bool?
    public let bouncesZoom: Bool?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let fontDescription: FontDescription?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let scrollEnabled: Bool?
    public let showsHorizontalScrollIndicator: Bool?
    public let showsVerticalScrollIndicator: Bool?
    public let subviews: [AnyView]?
    public let text: String
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    static func decode(_ xml: XMLIndexer) throws -> TextView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return TextView(
            id:                                        try container.attribute(of: .id),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            bounces:                                   container.attributeIfPresent(of: .bounces),
            bouncesZoom:                               container.attributeIfPresent(of: .bouncesZoom),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            fontDescription:                           xml.byKey("fontDescription").flatMap(decodeValue),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try decodeValue(xml.byKey("rect")),
            scrollEnabled:                             container.attributeIfPresent(of: .scrollEnabled),
            showsHorizontalScrollIndicator:            container.attributeIfPresent(of: .showsHorizontalScrollIndicator),
            showsVerticalScrollIndicator:              container.attributeIfPresent(of: .showsVerticalScrollIndicator),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            text:                                      try container.attribute(of: .text),
            textAlignment:                             container.attributeIfPresent(of: .textAlignment),
            textColor:                                 xml.byKey("color").flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.flatMap(decodeValue)
        )
    }
}
