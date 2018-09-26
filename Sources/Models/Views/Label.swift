//
//  Label.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Label: IBDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UILabel"

    public let adjustsFontSizeToFit: Bool?
    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let baselineAdjustment: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let fixedFrame: Bool?
    public let fontDescription: FontDescription?
    public let horizontalHuggingPriority: Int?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let isAmbiguous: Bool?
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
    public let variations: [Variation]?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> Label {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .textColor: return "color"
                case .attributedText: return "attributedString"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return Label(
            id:                                        try container.attribute(of: .id),
            adjustsFontSizeToFit:                      container.attributeIfPresent(of: .adjustsFontSizeToFit),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            baselineAdjustment:                        container.attributeIfPresent(of: .baselineAdjustment),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            fixedFrame:                                container.attributeIfPresent(of: .fixedFrame),
            fontDescription:                           container.elementIfPresent(of: .fontDescription),
            horizontalHuggingPriority:                 container.attributeIfPresent(of: .horizontalHuggingPriority),
            lineBreakMode:                             container.attributeIfPresent(of: .lineBreakMode),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
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
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation)
        )
    }

}

// MARK: - FontDescription

public struct FontDescription: IBDecodable, IBKeyable {
    public let key: String?
    public let type: String
    public let pointSize: Float
    public let weight: String?

    static func decode(_ xml: XMLIndexer) throws -> FontDescription {
        let container = xml.container(keys: CodingKeys.self)
        return FontDescription(
            key:       container.attributeIfPresent(of: .key),
            type:      try container.attribute(of: .type),
            pointSize: try container.attribute(of: .pointSize),
            weight:    container.attributeIfPresent(of: .weight)
        )
    }
}
