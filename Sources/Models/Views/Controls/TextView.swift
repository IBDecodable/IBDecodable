//
//  TextView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TextView: IBDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextView"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let bounces: Bool?
    public let bouncesZoom: Bool?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let fontDescription: FontDescription?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let scrollEnabled: Bool?
    public let showsHorizontalScrollIndicator: Bool?
    public let showsVerticalScrollIndicator: Bool?
    public let subviews: [AnyView]?
    public let text: String?
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let editable: Bool?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> TextView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .textColor: return "color"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return TextView(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            bounces:                                   container.attributeIfPresent(of: .bounces),
            bouncesZoom:                               container.attributeIfPresent(of: .bouncesZoom),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            fontDescription:                           container.elementIfPresent(of: .fontDescription),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try container.element(of: .rect),
            scrollEnabled:                             container.attributeIfPresent(of: .scrollEnabled),
            showsHorizontalScrollIndicator:            container.attributeIfPresent(of: .showsHorizontalScrollIndicator),
            showsVerticalScrollIndicator:              container.attributeIfPresent(of: .showsVerticalScrollIndicator),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            text:                                      container.attributeIfPresent(of: .text),
            textAlignment:                             container.attributeIfPresent(of: .textAlignment),
            textColor:                                 container.elementIfPresent(of: .textColor),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            editable:                                  container.attributeIfPresent(of: .editable)
        )
    }
}
