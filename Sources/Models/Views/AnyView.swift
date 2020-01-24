//
//  AnyView.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewProtocol

public protocol ViewProtocol: IBKeyable, IBCustomClassable, IBUserLabelable {
    var elementClass: String { get }

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
    var isAmbiguous: Bool? { get }
    var opaque: Bool? { get }
    var rect: Rect? { get }
    var subviews: [AnyView]? { get }
    var translatesAutoresizingMaskIntoConstraints: Bool? { get }
    var userInteractionEnabled: Bool? { get }
    var userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]? { get }
    var connections: [AnyConnection]? { get }
    var variations: [Variation]? { get }
    var backgroundColor: Color? { get }
    var tintColor: Color? { get }
}

// MARK: - AnyView

public struct AnyView: IBDecodable {

    public let view: ViewProtocol

    init(_ view: ViewProtocol) {
        self.view = view
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexerType) throws -> AnyView {
        guard let elementName = xml.elementName else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "activityIndicatorView":    return try AnyView(ActivityindicatorView.decode(xml))
        case "arscnView":                return try AnyView(ARSCNView.decode(xml))
        case "arskView":                 return try AnyView(ARSKView.decode(xml))
        case "button":                   return try AnyView(Button.decode(xml))
        case "collectionView":           return try AnyView(CollectionView.decode(xml))
        case "collectionViewCell":       return try AnyView(CollectionViewCell.decode(xml))
        case "collectionReusableView":   return try AnyView(CollectionReusableView.decode(xml))
        case "containerView":            return try AnyView(View.decode(xml))
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

// MARK: - AutoresizingMask

public struct AutoresizingMask: IBDecodable, IBKeyable {
    public let key: String?
    public let widthSizable: Bool
    public let heightSizable: Bool
    public let flexibleMaxX: Bool
    public let flexibleMaxY: Bool

    static func decode(_ xml: XMLIndexerType) throws -> AutoresizingMask {
        let container = xml.container(keys: CodingKeys.self)
        return AutoresizingMask(
            key:           container.attributeIfPresent(of: .key),
            widthSizable:  container.attributeIfPresent(of: .widthSizable) ?? false,
            heightSizable: container.attributeIfPresent(of: .heightSizable) ?? false,
            flexibleMaxX:  container.attributeIfPresent(of: .flexibleMaxX) ?? false,
            flexibleMaxY:  container.attributeIfPresent(of: .flexibleMaxY) ?? false
        )
    }
}

// MARK: - Constraint

public struct Constraint: IBDecodable, IBIdentifiable {
    public let id: String
    public let constant: Int?
    public let priority: Int?
    public let multiplier: String?
    public let firstItem: String?
    public let firstAttribute: LayoutAttribute?
    public let secondItem: String?
    public let secondAttribute: LayoutAttribute?
    public let relation: Relation

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

    public enum Relation: XMLAttributeDecodable, KeyDecodable, Equatable {
        case lessThanOrEqual, greaterThanOrEqual, equal

        case other(String)

        public func encode(to encoder: Encoder) throws { fatalError() }

        static func decode(_ attribute: XMLAttribute) throws -> Constraint.Relation {
            switch attribute.text {
            case "lessThanOrEqual":    return .lessThanOrEqual
            case "greaterThanOrEqual": return .greaterThanOrEqual
            default:                   return .other(attribute.text)
            }
        }
    }

    static func decode(_ xml: XMLIndexerType) throws -> Constraint {
        let container = xml.container(keys: CodingKeys.self)
        return Constraint(
            id:              try container.attribute(of: .id),
            constant:        container.attributeIfPresent(of: .constant),
            priority:        container.attributeIfPresent(of: .priority),
            multiplier:      container.attributeIfPresent(of: .multiplier),
            firstItem:       container.attributeIfPresent(of: .firstItem),
            firstAttribute:  container.attributeIfPresent(of: .firstAttribute),
            secondItem:      container.attributeIfPresent(of: .secondItem),
            secondAttribute: container.attributeIfPresent(of: .secondAttribute),
            relation:        container.attributeIfPresent(of: .relation) ?? .equal
        )
    }
}
