//
//  StackView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct StackView: XMLDecodable, KeyDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIStackView"

    public let alignment: String?
    public let autoresizingMask: AutoresizingMask?
    public let axis: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    static func decode(_ xml: XMLIndexer) throws -> StackView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return StackView(
            id:                                        try container.attribute(of: .id),
            alignment:                                 container.attributeIfPresent(of: .alignment),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            axis:                                      container.attributeIfPresent(of: .axis),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.compactMap(decodeValue),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.compactMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.compactMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.compactMap(decodeValue)
        )
    }
}
