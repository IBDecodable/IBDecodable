//
//  Label.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Label: XMLDecodable, KeyDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UILabel"

    public let adjustsFontSizeToFit: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let baselineAdjustment: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let horizontalHuggingPriority: Int?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let text: String?
    public let textAlignment: String?
    public let textColor: Color?
    public let attributedText: AttributedString?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let verticalHuggingPriority: Int?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    enum ConstraintsCodingKeys: CodingKey { case constraint }

    static func decode(_ xml: XMLIndexer) throws -> Label {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .font: return "fontDescription"
                case .textColor: return "color"
                case .attributedText: return "attributedString"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        
        return Label(
            id:                                        try container.attribute(of: .id),
            adjustsFontSizeToFit:                      container.attributeIfPresent(of: .adjustsFontSizeToFit),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            baselineAdjustment:                        container.attributeIfPresent(of: .baselineAdjustment),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            font:                                      container.elementIfPresent(of: .font),
            horizontalHuggingPriority:                 container.attributeIfPresent(of: .horizontalHuggingPriority),
            lineBreakMode:                             container.attributeIfPresent(of: .lineBreakMode),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try container.element(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            text:                                      container.attributeIfPresent(of: .text),
            textAlignment:                             container.attributeIfPresent(of: .textAlignment),
            textColor:                                 container.elementIfPresent(of: .textColor),
            attributedText:                            container.elementIfPresent(of: .attributedText),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            verticalHuggingPriority:                   container.attributeIfPresent(of: .verticalHuggingPriority),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections)
        )
    }

}

// MARK: - FontDescription

public struct FontDescription: XMLDecodable, KeyDecodable {
    public let type: String
    public let pointSize: Float
    public let weight: String?

    static func decode(_ xml: XMLIndexer) throws -> FontDescription {
        let container = xml.container(keys: CodingKeys.self)
        return FontDescription(
            type:      try container.attribute(of: .type),
            pointSize: try container.attribute(of: .pointSize),
            weight:    container.attributeIfPresent(of: .weight)
        )
    }
}
