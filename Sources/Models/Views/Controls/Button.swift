//
//  Button.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Button: IBDecodable, ViewProtocol, IBIdentifiable {
    public let id: String
    public let elementClass: String = "UIButton"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let buttonType: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let fixedFrame: Bool?
    public let fontDescription: FontDescription?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let isAmbiguous: Bool?
    public let verifyAmbiguity: VerifyAmbiguity?
    public let opaque: Bool?
    public let rect: Rect?
    public let subviews: [AnyView]?
    public let state: [State]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let hidden: Bool?

    public struct State: IBDecodable, IBKeyable {
        public let key: String?
        public let title: String?
        public let color: Color?
        public let image: String?
        public let catalog: String?
        public let attributedString: AttributedString?

        static func decode(_ xml: XMLIndexerType) throws -> Button.State {
            let container = xml.container(keys: CodingKeys.self)
            return State.init(
                key: try container.attribute(of: .key),
                title: container.attributeIfPresent(of: .title),
                color: container.elementIfPresent(of: .color),
                image: container.attributeIfPresent(of: .image),
                catalog: container.attributeIfPresent(of: .catalog),
                attributedString: container.elementIfPresent(of: .attributedString)
            )
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color }
    enum ColorsCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> Button {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

        return Button(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            buttonType:                                container.attributeIfPresent(of: .buttonType),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentHorizontalAlignment:                container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                  container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            fixedFrame:                                container.attributeIfPresent(of: .fixedFrame),
            fontDescription:                           container.elementIfPresent(of: .fontDescription),
            lineBreakMode:                             container.attributeIfPresent(of: .lineBreakMode),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
            verifyAmbiguity:                           container.attributeIfPresent(of: .verifyAmbiguity),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            state:                                     container.elementsIfPresent(of: .state),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            hidden:                                    container.attributeIfPresent(of: .hidden)
        )
    }
}
