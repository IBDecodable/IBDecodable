//
//  AnyView.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewProtocol

public protocol ViewProtocol: IBIdentifiable, IBKeyable, IBCustomClassable, IBUserLabelable {
    var elementClass: String { get }
    var id: String { get }

    var key: String? { get }
    var autoresizingMask: AutoresizingMask? { get }
    var clipsSubviews: Bool? { get }
    var constraints: [Constraint]? { get }
    var contentMode: String? { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var userLabel: String? { get }
    var colorLabel: String? { get }
    var isMisplaced: Bool? { get }
    var opaque: Bool? { get }
    var rect: Rect { get }
    var subviews: [AnyView]? { get }
    var translatesAutoresizingMaskIntoConstraints: Bool? { get }
    var userInteractionEnabled: Bool? { get }
    var userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]? { get }
    var connections: [AnyConnection]? { get }

}

// MARK: - AnyView

public struct AnyView: IBDecodable {

    public let view: ViewProtocol

    init(_ view: ViewProtocol) {
        self.view = view
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexer) throws -> AnyView {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "activityIndicatorView":    return try AnyView(ActivityindicatorView.decode(xml))
        case "arscnView":                return try AnyView(ARSCNView.decode(xml))
        case "arskView":                 return try AnyView(ARSKView.decode(xml))
        case "button":                   return try AnyView(Button.decode(xml))
        case "collectionView":           return try AnyView(CollectionView.decode(xml))
        case "collectionViewCell":       return try AnyView(CollectionViewCell.decode(xml))
        case "datePicker":               return try AnyView(DatePicker.decode(xml))
        case "glkView":                  return try AnyView(GLKView.decode(xml))
        case "imageView":                return try AnyView(ImageView.decode(xml))
        case "label":                    return try AnyView(Label.decode(xml))
        case "mapView":                  return try AnyView(MapView.decode(xml))
        case "mtkView":                  return try AnyView(MTKView.decode(xml))
        case "navigationBar":            return try AnyView(NavigationBar.decode(xml))
        case "pageControl":              return try AnyView(PageControl.decode(xml))
        case "pickerView":               return try AnyView(PickerView.decode(xml))
        case "progressView":             return try AnyView(ProgressView.decode(xml))
        case "sceneKitView":             return try AnyView(SceneKitView.decode(xml))
        case "scrollView":               return try AnyView(ScrollView.decode(xml))
        case "searchBar":                return try AnyView(SearchBar.decode(xml))
        case "segmentedControl":         return try AnyView(SegmentedControl.decode(xml))
        case "skView":                   return try AnyView(SKView.decode(xml))
        case "slider":                   return try AnyView(Slider.decode(xml))
        case "stackView":                return try AnyView(StackView.decode(xml))
        case "stepper":                  return try AnyView(Stepper.decode(xml))
        case "switch":                   return try AnyView(Switch.decode(xml))
        case "tabBar":                   return try AnyView(TabBar.decode(xml))
        case "tableView":                return try AnyView(TableView.decode(xml))
        case "tableViewCell":            return try AnyView(TableViewCell.decode(xml))
        case "tableViewCellContentView": return try AnyView(TableViewCell.TableViewContentView.decode(xml))
        case "textField":                return try AnyView(TextField.decode(xml))
        case "textView":                 return try AnyView(TextView.decode(xml))
        case "toolbar":                  return try AnyView(Toolbar.decode(xml))
        case "view":                     return try AnyView(View.decode(xml))
        case "visualEffectView":         return try AnyView(VisualEffectView.decode(xml))
        case "wkWebView":                return try AnyView(WKWebView.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

}

extension AnyView: IBAny {
    public typealias NestedElement = ViewProtocol
    public var nested: ViewProtocol {
        return view
    }
}

// MARK: - Rect

public struct Rect: IBDecodable, IBKeyable {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Rect {
        let container = xml.container(keys: CodingKeys.self)
        return Rect(
            x:      try container.attribute(of: .x),
            y:      try container.attribute(of: .y),
            width:  try container.attribute(of: .width),
            height: try container.attribute(of: .height),
            key:    container.attributeIfPresent(of: .key)
        )
    }
}

// MARK: - Point

public struct Point: IBDecodable, IBKeyable {
    public let x: Float
    public let y: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Point {
        let container = xml.container(keys: CodingKeys.self)
        return Point(
            x:      try container.attribute(of: .x),
            y:      try container.attribute(of: .y),
            key:    container.attributeIfPresent(of: .key)
        )
    }
}

// MARK: - Size

public struct Size: IBDecodable, IBKeyable {
    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Size {
        let container = xml.container(keys: CodingKeys.self)
        return Size(
            width:  try container.attribute(of: .width),
            height: try container.attribute(of: .height),
            key:    container.attributeIfPresent(of: .key)
        )
    }
}

// MARK: - Inset

public struct Inset: IBDecodable, IBKeyable {
    public let minX: Float
    public let minY: Float
    public let maxX: Float
    public let maxY: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Inset {
        let container = xml.container(keys: CodingKeys.self)
        return Inset(
            minX: try container.attribute(of: .minX),
            minY: try container.attribute(of: .minY),
            maxX: try container.attribute(of: .maxX),
            maxY: try container.attribute(of: .maxY),
            key:  container.attributeIfPresent(of: .key)
        )
    }
}

// MARK: - AutoresizingMask

public struct AutoresizingMask: IBDecodable, IBKeyable {
    public let widthSizable: Bool
    public let heightSizable: Bool
    public let key: String?
    public let flexibleMaxX: Bool
    public let flexibleMaxY: Bool

    static func decode(_ xml: XMLIndexer) throws -> AutoresizingMask {
        let container = xml.container(keys: CodingKeys.self)
        return try AutoresizingMask(
            widthSizable:  container.attribute(of: .widthSizable),
            heightSizable: container.attribute(of: .heightSizable),
            key:           container.attribute(of: .key),
            flexibleMaxX:  container.attribute(of: .flexibleMaxX),
            flexibleMaxY:  container.attribute(of: .flexibleMaxY)
        )
    }
}

// MARK: - Constraint

public struct Constraint: IBDecodable, IBIdentifiable {
    public let id: String
    public let constant: Int?
    public let multiplier: String?
    public let firstItem: String?
    public let firstAttribute: LayoutAttribute?
    public let secondItem: String?
    public let secondAttribute: LayoutAttribute?

    public enum LayoutAttribute: XMLAttributeDecodable, KeyDecodable, Equatable {
        case left, right, top, bottom, leading, trailing,
        width, height, centerX, centerY

        case leftMargin, rightMargin, topMargin,
        bottomMargin, leadingMargin, trailingMargin

        case other(String)

        public func encode(to encoder: Encoder) throws { fatalError() }

        static func decode(_ attribute: XMLAttribute) throws -> Constraint.LayoutAttribute {
            switch attribute.text {
            case "left":           return .left
            case "right":          return .right
            case "top":            return .top
            case "bottom":         return .bottom
            case "leading":        return .leading
            case "trailing":       return .trailing
            case "width":          return .width
            case "height":         return .height
            case "centerX":        return .centerX
            case "centerY":        return .centerY
            case "leftMargin":     return .leftMargin
            case "rightMargin":    return .rightMargin
            case "topMargin":      return .topMargin
            case "bottomMargin":   return .bottomMargin
            case "leadingMargin":  return .leadingMargin
            case "trailingMargin": return .trailingMargin
            default:               return .other(attribute.text)
            }
        }

        public static func == (lhs: LayoutAttribute, rhs: LayoutAttribute) -> Bool {
            switch (lhs, rhs) {
            case (.left, .left), (.right, .right), (.top, .top), (.bottom, .bottom),
                 (.leading, .leading), (.trailing, .trailing), (.width, .width),
                 (.height, height), (.centerX, .centerX), (.centerY, .centerY),
                 (.leftMargin, .leftMargin), (.rightMargin, .rightMargin),
                 (.topMargin, .topMargin), (.bottomMargin, .bottomMargin),
                 (.leadingMargin, .leadingMargin), (.trailingMargin, .trailingMargin): return true
            case (.other(let msg1), .other(let msg2)): return msg1 == msg2
            default: return false
            }
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Constraint {
        let container = xml.container(keys: CodingKeys.self)
        return Constraint(
            id:              try container.attribute(of: .id),
            constant:        container.attributeIfPresent(of: .constant),
            multiplier:      container.attributeIfPresent(of: .multiplier),
            firstItem:       container.attributeIfPresent(of: .firstItem),
            firstAttribute:  container.attributeIfPresent(of: .firstAttribute),
            secondItem:      container.attributeIfPresent(of: .secondItem),
            secondAttribute: container.attributeIfPresent(of: .secondAttribute)
        )
    }
}

// MARK: - Color

public enum Color: IBDecodable {

    public typealias CalibratedWhite = (key: String?, white: Float, alpha: Float)
    public typealias SRGB = (key: String?, red: Float, blue: Float, green: Float, alpha: Float)
    public typealias Named = (key: String?, name: String)
    case calibratedWhite(CalibratedWhite)
    case sRGB(SRGB)
    case name(Named)
    case systemColor(Named)

    public var sRGB: SRGB? {
        switch self {
        case .sRGB(let sRGB):
            return sRGB
        default: return nil
        }
    }

    public var calibratedWhite: CalibratedWhite? {
        switch self {
        case .calibratedWhite(let calibratedWhite):
            return calibratedWhite
        default: return nil
        }
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    enum CodingKeys: CodingKey {
        case key
        case colorSpace
        case cocoaTouchSystemColor
    }

    enum CalibratedWhiteCodingKeys: CodingKey {
        case white, alpha
    }

    enum sRGBCodingKeys: CodingKey {
        case red, blue, green, alpha
    }

    enum CustomCodingKeys: CodingKey {
        case customColorSpace
    }

    enum NamedCodingKeys: CodingKey {
        case name
    }

    static func decode(_ xml: XMLIndexer) throws -> Color {
        let container = xml.container(keys: CodingKeys.self)
        let key: String? = container.attributeIfPresent(of: .key)
        if let colorSpace: String = container.attributeIfPresent(of: .colorSpace) {
            switch colorSpace {
            case "calibratedWhite":
                let calibratedWhiteContainer = xml.container(keys: CalibratedWhiteCodingKeys.self)
                return try .calibratedWhite((key:   key,
                                             white: calibratedWhiteContainer.attribute(of: .white),
                                             alpha: calibratedWhiteContainer.attribute(of: .alpha)))
            case "custom":
                let container = xml.container(keys: CustomCodingKeys.self)
                let customColorSpace: String = try container.attribute(of: .customColorSpace)
                switch customColorSpace {
                case "sRGB":
                    let sRGBContainer = xml.container(keys: sRGBCodingKeys.self)
                    return try .sRGB((key:   key,
                                      red:   sRGBContainer.attribute(of: .red),
                                      blue:  sRGBContainer.attribute(of: .blue),
                                      green: sRGBContainer.attribute(of: .green),
                                      alpha: sRGBContainer.attribute(of: .alpha)
                    ))
                default:
                    throw IBError.unsupportedColorSpace(customColorSpace)
                }
            default:
                throw IBError.unsupportedColorSpace(colorSpace)
            }
        } else {
            if let systemColor: String = container.attributeIfPresent(of: .cocoaTouchSystemColor) {
                return .systemColor((key, systemColor))
            }
            let container = xml.container(keys: NamedCodingKeys.self)
            return .name((key, try container.attribute(of: .name)))
        }
    }
}

// MARK: AttributeProtocol

extension Color: AttributeProtocol {

    public var key: String? {
        switch self {
        case .calibratedWhite(let calibratedWhite):
            return calibratedWhite.key
        case .sRGB(let srgb):
            return srgb.key
        case .name(let named):
            return named.key
        case .systemColor(let named):
            return named.key
        }
    }

}
