//
//  CollectionView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - CollectionView

public struct CollectionView: IBDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UICollectionView"

    public let alwaysBounceHorizontal: Bool?
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
    public let cells: [CollectionViewCell]?
    public let layout: CollectionViewLayout?
    public let flowLayout: CollectionViewFlowLayout?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> CollectionView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .layout: return "collectionViewLayout"
                case .flowLayout: return "collectionViewFlowLayout"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return CollectionView(
            id:                                        try container.attribute(of: .id),
            alwaysBounceHorizontal:                    container.attributeIfPresent(of: .alwaysBounceHorizontal),
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
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            cells:                                     container.childrenIfPresent(of: .cells),
            layout:                                    container.elementIfPresent(of: .layout),
            flowLayout:                                container.elementIfPresent(of: .flowLayout)
        )
    }
}

// MARK: - CollectionViewCell

public struct CollectionViewCell: IBDecodable, ViewProtocol, IBReusable {
    public let id: String
    public let elementClass: String = "UICollectionViewCell"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: View
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

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewCell {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case ._subviews: return "subview"
                case .contentView: return "view"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return CollectionViewCell(
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

// MARK: - CollectionViewLayout

public struct CollectionViewLayout: IBDecodable, IBIdentifiable, IBKeyable, IBCustomClassable {

    public let id: String
    public let key: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewLayout {
        let container = xml.container(keys: CodingKeys.self)
        return CollectionViewLayout(
            id:                       try container.attribute(of: .id),
            key:                      container.attributeIfPresent(of: .key),
            customClass:              container.attributeIfPresent(of: .customClass),
            customModule:             container.attributeIfPresent(of: .customModule),
            customModuleProvider:     container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                container.attributeIfPresent(of: .userLabel),
            colorLabel:               container.attributeIfPresent(of: .colorLabel)
        )
    }
}

// MARK: - CollectionViewFlowLayout

public struct CollectionViewFlowLayout: IBDecodable, IBIdentifiable, IBKeyable {

    public let id: String
    public let key: String?
    public let minimumLineSpacing: String?
    public let minimumInteritemSpacing: String?
    public let sizes: [Size]?
    public let insets: [Inset]?

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewFlowLayout {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .key: return "contentMode"
                case .sizes: return "size"
                case .insets: return "inset"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        return CollectionViewFlowLayout(
            id:                       try container.attribute(of: .id),
            key:                      container.attributeIfPresent(of: .key),
            minimumLineSpacing:       container.attributeIfPresent(of: .minimumLineSpacing),
            minimumInteritemSpacing:  container.attributeIfPresent(of: .minimumInteritemSpacing),
            sizes:                    container.elementsIfPresent(of: .sizes),
            insets:                   container.elementsIfPresent(of: .insets)
        )
    }
}
