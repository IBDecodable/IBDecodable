//
//  Label.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Label: IBDecodable, ViewProtocol, IBIdentifiable {

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
    public let verifyAmbiguity: VerifyAmbiguity?
    public let opaque: Bool?
    public let rect: Rect?
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
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let isHidden: Bool?
    public let alpha: Float?
    public let numberOfLines: Int?
    public let adjustsFontForContentSizeCategory: Bool?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color, string }
    enum ColorsCodingKeys: CodingKey { case key }
    enum StringsCodingKeys: CodingKey { case key }
    
    static func decode(_ xml: XMLIndexerType) throws -> Label {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .isHidden: return "hidden"
                case .attributedText: return "attributedString"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)
        let stringsContainer = xml.container(keys: ExternalCodingKeys.self).nestedContainerIfPresent(of: .string, keys: StringsCodingKeys.self)

        var text: String? = container.attributeIfPresent(of: .text)
        if text == nil {
            let multiLineText: StringElement? = stringsContainer?.withAttributeElement(.key, CodingKeys.text.stringValue)
            text = multiLineText?.elementValue
        }
        
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
            verifyAmbiguity:                           container.attributeIfPresent(of: .verifyAmbiguity),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            text:                                      text,
            textAlignment:                             container.attributeIfPresent(of: .textAlignment),
            textColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.textColor.stringValue),
            attributedText:                            container.elementIfPresent(of: .attributedText),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            verticalHuggingPriority:                   container.attributeIfPresent(of: .verticalHuggingPriority),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            isHidden:                                  container.attributeIfPresent(of: .isHidden),
            alpha:                                     container.attributeIfPresent(of: .alpha),
            numberOfLines:                             container.attributeIfPresent(of: .numberOfLines),
            adjustsFontForContentSizeCategory:         container.attributeIfPresent(of: .adjustsFontForContentSizeCategory)
        )
    }

}

// MARK: - FontDescription

public enum FontDescription: IBDecodable {
    public typealias SystemFont = (key: String?, type: String, weight: String?, pointSize: Float)
    public typealias CustomFont = (key: String?, name: String, family: String, pointSize: Float)
    public typealias TextStyle = (key: String?, style: String)
    case system(SystemFont)
    case custom(CustomFont)
    case textStyle(TextStyle)

    public var pointSize: Float? {
        switch self {
        case .system(let systemFont):
            return systemFont.pointSize
        case .custom(let customFont):
            return customFont.pointSize
        case .textStyle:
            return nil
        }
    }

    enum CodingKeys: CodingKey {
        case key, type, weight, pointSize, name, family, style
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexerType) throws -> FontDescription {
        let container = xml.container(keys: CodingKeys.self)
        let key: String? = container.attributeIfPresent(of: .key)
        if let type: String = container.attributeIfPresent(of: .type) {
            return try .system((key: key,
                                type: type,
                                weight: container.attributeIfPresent(of: .weight),
                                pointSize: container.attribute(of: .pointSize)
            ))
        } else if let name: String = container.attributeIfPresent(of: .name),
            let family: String = container.attributeIfPresent(of: .family) {
            return try .custom((key: key,
                                name: name,
                                family: family,
                                pointSize: container.attribute(of: .pointSize)
            ))
        } else if let style: String = container.attributeIfPresent(of: .style) {
            return .textStyle((key: key,
                               style: style
            ))
        } else {
            throw IBError.unsupportedFontDescription
        }
    }
}

extension FontDescription: AttributeProtocol {

    public var key: String? {
        switch self {
        case .system(let systemFont):
            return systemFont.key
        case .custom(let customFont):
            return customFont.key
        case .textStyle(let textStyle):
            return textStyle.key
        }
    }
}
