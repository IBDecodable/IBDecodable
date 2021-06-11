//
//  Slider.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct Slider: IBDecodable, ControlProtocol, IBIdentifiable {
    public let id: String
    public let elementClass: String = "UISlider"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let isMisplaced: Bool?
    public let isAmbiguous: Bool?
    public let verifyAmbiguity: VerifyAmbiguity?
    public let opaque: Bool?
    public let rect: Rect?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let viewLayoutGuide: LayoutGuide?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let isHidden: Bool?
    public let alpha: Float?

    public let isEnabled: Bool?
    public let isHighlighted: Bool?
    public let isSelected: Bool?
    public let contentHorizontalAlignment: String?
    public let contentVerticalAlignment: String?

    public let minimumTrackTintColor: Color?
    public let maximumTrackTintColor: Color?
    public let thumbTintColor: Color?

    public let value: String?
    public let minValue: String?
    public let maxValue: String?
    public let minimumValueImage: String?
    public let maximumValueImage: String?
    public let continuous: Bool

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color }
    enum ColorsCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> Slider {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .isHidden: return "hidden"
                case .isEnabled: return "enabled"
                case .isHighlighted: return "highlighted"
                case .isSelected: return "selected"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

        return Slider(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
            verifyAmbiguity:                           container.attributeIfPresent(of: .verifyAmbiguity),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            viewLayoutGuide:                           container.elementIfPresent(of: .viewLayoutGuide),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            isHidden:                                  container.attributeIfPresent(of: .isHidden),
            alpha:                                     container.attributeIfPresent(of: .alpha),
            isEnabled:                                 container.attributeIfPresent(of: .isEnabled),
            isHighlighted:                             container.attributeIfPresent(of: .isHighlighted),
            isSelected:                                container.attributeIfPresent(of: .isSelected),
            contentHorizontalAlignment:                container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentVerticalAlignment:                  container.attributeIfPresent(of: .contentVerticalAlignment),
            minimumTrackTintColor:                     colorsContainer?.withAttributeElement(.key, CodingKeys.minimumTrackTintColor.stringValue),
            maximumTrackTintColor:                     colorsContainer?.withAttributeElement(.key, CodingKeys.maximumTrackTintColor.stringValue),
            thumbTintColor:                            colorsContainer?.withAttributeElement(.key, CodingKeys.thumbTintColor.stringValue),
            value:                                     container.attributeIfPresent(of: .value),
            minValue:                                  container.attributeIfPresent(of: .minValue),
            maxValue:                                  container.attributeIfPresent(of: .maxValue),
            minimumValueImage:                         container.attributeIfPresent(of: .minimumValueImage),
            maximumValueImage:                         container.attributeIfPresent(of: .maximumValueImage),
            continuous:                                container.attributeIfPresent(of: .continuous) ?? true
        )
    }
}
