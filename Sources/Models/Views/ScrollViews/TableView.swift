//
//  TableView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - TableView

public struct TableView: IBDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UITableView"

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
    public let dataMode: DataMode?
    public let estimatedRowHeight: Float?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let rowHeight: Float?
    public let sectionFooterHeight: Float?
    public let sectionHeaderHeight: Float?
    public let separatorStyle: String?
    public let style: String?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let sections: [TableViewSection]?
    public let prototypeCells: [TableViewCell]?
    public let isPagingEnabled: Bool?
    public let bouncesZoom: Bool?
    public let bounces: Bool?
    public let alwaysBounceVertical: Bool?
    public let keyboardDismissMode: String?
    public let showsVerticalScrollIndicator: Bool?
    public let showsHorizontalScrollIndicator: Bool?
    public let maximumZoomScale: Float?
    public let minimumZoomScale: Float?
    public let isDirectionalLockEnabled: Bool?

    public enum DataMode: XMLAttributeDecodable, KeyDecodable, Equatable {
        case `static`, prototypes

        public func encode(to encoder: Encoder) throws { fatalError() }

        static func decode(_ attribute: XMLAttribute) throws -> TableView.DataMode {
            switch attribute.text {
            case "static":     return .static
            case "prototypes": return .prototypes
            default:
                throw IBError.unsupportedTableViewDataMode(attribute.text)
            }
        }

        public static func == (left: DataMode, right: DataMode) -> Bool {
            switch (left, right) {
            case (.`static`, .`static`):
                return true
            case (.prototypes, .prototypes):
                return true
            default:
                return false
            }
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> TableView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .prototypeCells: return "prototypes"
                case .isPagingEnabled: return "pagingEnabled"
                case .isDirectionalLockEnabled: return "directionalLockEnabled"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return TableView(
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
            dataMode:                                  container.attributeIfPresent(of: .dataMode),
            estimatedRowHeight:                        container.attributeIfPresent(of: .estimatedRowHeight),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try container.element(of: .rect),
            rowHeight:                                 container.attributeIfPresent(of: .rowHeight),
            sectionFooterHeight:                       container.attributeIfPresent(of: .sectionFooterHeight),
            sectionHeaderHeight:                       container.attributeIfPresent(of: .sectionHeaderHeight),
            separatorStyle:                            container.attributeIfPresent(of: .separatorStyle),
            style:                                     container.attributeIfPresent(of: .style),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            sections:                                  container.childrenIfPresent(of: .sections),
            prototypeCells:                            container.childrenIfPresent(of: .prototypeCells),
            isPagingEnabled:                           container.attributeIfPresent(of: .isPagingEnabled),
            bouncesZoom:                               container.attributeIfPresent(of: .bouncesZoom),
            bounces:                                   container.attributeIfPresent(of: .bounces),
            alwaysBounceVertical:                      container.attributeIfPresent(of: .alwaysBounceVertical),
            keyboardDismissMode:                       container.attributeIfPresent(of: .keyboardDismissMode),
            showsVerticalScrollIndicator:              container.attributeIfPresent(of: .showsVerticalScrollIndicator),
            showsHorizontalScrollIndicator:            container.attributeIfPresent(of: .showsHorizontalScrollIndicator),
            maximumZoomScale:                          container.attributeIfPresent(of: .maximumZoomScale),
            minimumZoomScale:                          container.attributeIfPresent(of: .minimumZoomScale),
            isDirectionalLockEnabled:                  container.attributeIfPresent(of: .isDirectionalLockEnabled)
        )
    }
}

// MARK: - TableViewSection

public struct TableViewSection: IBDecodable {

    public let id: String
    public let headerTitle: String?
    public let footerTitle: String?
    public let colorLabel: String?
    public let cells: [TableViewCell]?
    public let userComments: AttributedString?

    enum ExternalCodingKeys: CodingKey { case attributedString }
    enum AttributedStringCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexer) throws -> TableViewSection {
        assert(xml.element?.name == "tableViewSection")
        let container = xml.container(keys: CodingKeys.self)
        let attributedStringContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .attributedString, keys: AttributedStringCodingKeys.self)
        return TableViewSection(
            id:           try container.attribute(of: .id),
            headerTitle:  container.attributeIfPresent(of: .headerTitle),
            footerTitle:  container.attributeIfPresent(of: .footerTitle),
            colorLabel:   container.attributeIfPresent(of: .colorLabel),
            cells:        container.childrenIfPresent(of: .cells),
            userComments: attributedStringContainer?.withAttributeElement(.key, "userComments")
        )
    }
}
// MARK: - TableViewCell

public struct TableViewCell: IBDecodable, ViewProtocol, IBReusable {

    public let id: String
    public let elementClass: String = "UITableView"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: TableViewContentView
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    private let _subviews: [AnyView]?
    public var subviews: [AnyView]? {
        return (_subviews ?? []) + [AnyView(contentView)]
    }
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let reuseIdentifier: String?

    public var children: [IBElement] {
        // do not let default implementation which lead to duplicate element contentView
        var children: [IBElement] = [contentView] + [rect]
        if let elements = constraints {
            children += elements as [IBElement]
        }
        if let elements = _subviews {
            children += elements as [IBElement]
        }
        if let elements = userDefinedRuntimeAttributes {
            children += elements as [IBElement]
        }
        if let elements = connections {
            children += elements as [IBElement]
        }
        return children
    }

    public struct TableViewContentView: IBDecodable, ViewProtocol {
        public let id: String
        public let elementClass: String = "UITableViewContentView"

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
        public let opaque: Bool?
        public let rect: Rect
        public let subviews: [AnyView]?
        public let translatesAutoresizingMaskIntoConstraints: Bool?
        public let userInteractionEnabled: Bool?
        public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
        public let connections: [AnyConnection]?
        public let variations: [Variation]?

        static func decode(_ xml: XMLIndexer) throws -> TableViewCell.TableViewContentView {
            let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
                let stringValue: String = {
                    switch key {
                    case .isMisplaced: return "misplaced"
                    default: return key.stringValue
                    }
                }()
                return MappedCodingKey(stringValue: stringValue)
            }
            let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

            return TableViewContentView(
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
                opaque:                                    container.attributeIfPresent(of: .opaque),
                rect:                                      try container.element(of: .rect),
                subviews:                                  container.childrenIfPresent(of: .subviews),
                translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
                userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
                userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
                connections:                               container.childrenIfPresent(of: .connections),
                variations:                                variationContainer.elementsIfPresent(of: .variation)
            )
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> TableViewCell {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case ._subviews: return "subview"
                case .contentView: return "tableViewCellContentView"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return TableViewCell(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentView:                               try container.element(of: .contentView),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try container.element(of: .rect),
            _subviews:                                 container.childrenIfPresent(of: ._subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            reuseIdentifier:                           container.attributeIfPresent(of: .reuseIdentifier)
        )
    }
}
