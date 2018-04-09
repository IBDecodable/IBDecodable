//
//  AnyView.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewProtocol

public protocol ViewProtocol {
    var elementClass: String { get }
    var id: String { get }

    var autoresizingMask: AutoresizingMask? { get }
    var clipsSubviews: Bool? { get }
    var constraints: [Constraint]? { get }
    var contentMode: String? { get }
    var customClass: String? { get }
    var customModule: String? { get }
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

public struct AnyView: XMLDecodable {

    public let view: ViewProtocol

    init(_ view: ViewProtocol) {
        self.view = view
    }

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

// MARK: - Rect

public struct Rect: XMLDecodable {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Rect {
        return Rect(
            x:      try xml.attributeValue(of: "x"),
            y:      try xml.attributeValue(of: "y"),
            width:  try xml.attributeValue(of: "width"),
            height: try xml.attributeValue(of: "height"),
            key:    xml.attributeValue(of: "key")
        )
    }
}

// MARK: - Point

public struct Point: XMLDecodable {
    public let x: Float
    public let y: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Point {
        return Point(
            x:      try xml.attributeValue(of: "x"),
            y:      try xml.attributeValue(of: "y"),
            key:    xml.attributeValue(of: "key")
        )
    }
}

// MARK: - Size

public struct Size: XMLDecodable {
    public let width: Float
    public let height: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Size {
        return Size(
            width:  try xml.attributeValue(of: "width"),
            height: try xml.attributeValue(of: "height"),
            key:    xml.attributeValue(of: "key")
        )
    }
}

// MARK: - Inset

public struct Inset: XMLDecodable {
    public let minX: Float
    public let minY: Float
    public let maxX: Float
    public let maxY: Float
    public let key: String?

    static func decode(_ xml: XMLIndexer) throws -> Inset {
        return Inset(
            minX: try xml.attributeValue(of: "minX"),
            minY: try xml.attributeValue(of: "minY"),
            maxX: try xml.attributeValue(of: "maxX"),
            maxY: try xml.attributeValue(of: "maxY"),
            key:  xml.attributeValue(of: "key")
        )
    }
}

// MARK: - AutoresizingMask

public struct AutoresizingMask: XMLDecodable {
    public let widthSizable: Bool
    public let heightSizable: Bool
    public let key: String?
    public let flexibleMaxX: Bool
    public let flexibleMaxY: Bool

    static func decode(_ xml: XMLIndexer) throws -> AutoresizingMask {
        return try AutoresizingMask(
            widthSizable:  xml.attributeValue(of: "widthSizable"),
            heightSizable: xml.attributeValue(of: "heightSizable"),
            key:           xml.attributeValue(of: "key"),
            flexibleMaxX:  xml.attributeValue(of: "flexibleMaxX"),
            flexibleMaxY:  xml.attributeValue(of: "flexibleMaxY")
        )
    }
}

// MARK: - Constraint

public struct Constraint: XMLDecodable {
    public let id: String
    public let constant: Int?
    public let multiplier: String?
    public let firstItem: String?
    public let firstAttribute: LayoutAttribute?
    public let secondItem: String?
    public let secondAttribute: LayoutAttribute?

    public enum LayoutAttribute: XMLAttributeDecodable, Equatable {
        case left, right, top, bottom, leading, trailing,
        width, height, centerX, centerY

        case leftMargin, rightMargin, topMargin,
        bottomMargin, leadingMargin, trailingMargin

        case other(String)

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
        return Constraint(
            id:              try xml.attributeValue(of: "id"),
            constant:        xml.attributeValue(of: "constant"),
            multiplier:      xml.attributeValue(of: "multiplier"),
            firstItem:       xml.attributeValue(of: "firstItem"),
            firstAttribute:  xml.attributeValue(of: "firstAttribute"),
            secondItem:      xml.attributeValue(of: "secondItem"),
            secondAttribute: xml.attributeValue(of: "secondAttribute")
        )
    }
}

// MARK: - Color

public enum Color: XMLDecodable {

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

    static func decode(_ xml: XMLIndexer) throws -> Color {
        let key: String? = xml.attributeValue(of: "key")
        if let colorSpace: String = xml.attributeValue(of: "colorSpace") {
            switch colorSpace {
            case "calibratedWhite":
                return try .calibratedWhite((key:   key,
                                             white: xml.attributeValue(of: "white"),
                                             alpha: xml.attributeValue(of: "alpha")))
            case "custom":
                let customColorSpace: String = try xml.attributeValue(of: "customColorSpace")
                switch customColorSpace {
                case "sRGB":
                    return try .sRGB((key:   key,
                                      red:   xml.attributeValue(of: "red"),
                                      blue:  xml.attributeValue(of: "blue"),
                                      green: xml.attributeValue(of: "green"),
                                      alpha: xml.attributeValue(of: "alpha")
                    ))
                default:
                    throw IBError.unsupportedColorSpace(customColorSpace)
                }
            default:
                throw IBError.unsupportedColorSpace(colorSpace)
            }
        } else {
            if let systemColor: String = xml.attributeValue(of: "cocoaTouchSystemColor") {
                return .systemColor((key, systemColor))
            }
            return .name((key, try xml.attributeValue(of: "name")))
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
