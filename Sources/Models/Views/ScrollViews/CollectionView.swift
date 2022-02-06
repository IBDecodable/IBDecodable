//
//  CollectionView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - CollectionView

public struct CollectionView: IBDecodable, ViewProtocol, IBIdentifiable {
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
    public let isAmbiguous: Bool?
    public let verifyAmbiguity: VerifyAmbiguity?
    public let opaque: Bool?
    public let rect: Rect?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let cells: [CollectionViewCell]?
    public let collectionReusableViews: [CollectionReusableView]?
    public var sectionHeaderView: CollectionReusableView? {
        return collectionReusableViews?.first(where: { $0.key == "sectionHeaderView" })
    }
    public var sectionFooterView: CollectionReusableView? {
        return collectionReusableViews?.first(where: { $0.key == "sectionFooterView" })
    }
    public let layout: CollectionViewLayout?
    public let flowLayout: CollectionViewFlowLayout?
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
    public let isPrefetchingEnabled: Bool?
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let isHidden: Bool?
    public let alpha: Float?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color }
    enum ColorsCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> CollectionView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .isHidden: return "hidden"
                case .isPagingEnabled: return "pagingEnabled"
                case .layout: return "collectionViewLayout"
                case .flowLayout: return "collectionViewFlowLayout"
                case .isDirectionalLockEnabled: return "directionalLockEnabled"
                case .isPrefetchingEnabled: return "prefetchingEnabled"
                case .collectionReusableViews: return "collectionReusableView"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

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
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
            verifyAmbiguity:                           container.attributeIfPresent(of: .verifyAmbiguity),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            cells:                                     container.childrenIfPresent(of: .cells),
            collectionReusableViews:                   container.elementsIfPresent(of: .collectionReusableViews),
            layout:                                    container.elementIfPresent(of: .layout),
            flowLayout:                                container.elementIfPresent(of: .flowLayout),
            isPagingEnabled:                           container.attributeIfPresent(of: .isPagingEnabled),
            bouncesZoom:                               container.attributeIfPresent(of: .bouncesZoom),
            bounces:                                   container.attributeIfPresent(of: .bounces),
            alwaysBounceVertical:                      container.attributeIfPresent(of: .alwaysBounceVertical),
            keyboardDismissMode:                       container.attributeIfPresent(of: .keyboardDismissMode),
            showsVerticalScrollIndicator:              container.attributeIfPresent(of: .showsVerticalScrollIndicator),
            showsHorizontalScrollIndicator:            container.attributeIfPresent(of: .showsHorizontalScrollIndicator),
            maximumZoomScale:                          container.attributeIfPresent(of: .maximumZoomScale),
            minimumZoomScale:                          container.attributeIfPresent(of: .minimumZoomScale),
            isDirectionalLockEnabled:                  container.attributeIfPresent(of: .isDirectionalLockEnabled),
            isPrefetchingEnabled:                      container.attributeIfPresent(of: .isPrefetchingEnabled),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            isHidden:                                  container.attributeIfPresent(of: .isHidden),
            alpha:                                     container.attributeIfPresent(of: .alpha)
        )
    }
}

// MARK: - CollectionViewCell

public struct CollectionViewCell: IBDecodable, ViewProtocol, IBIdentifiable, IBReusable {
    public let id: String
    public let elementClass: String = "UICollectionViewCell"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: CollectionViewContentView
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
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let isHidden: Bool?
    public let alpha: Float?
    
    public var children: [IBElement] {
        // do not let default implementation which lead to duplicate element contentView
        var children: [IBElement] = [contentView] + (rect.map { [$0] } ?? [])
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

    public struct CollectionViewContentView: IBDecodable, ViewProtocol {

        /// - Note: Exists only in newer versions with `collectionViewCellContentView` key
        public let id: String?
        
        public let elementClass: String = "UIView"

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
        
        enum ConstraintsCodingKeys: CodingKey { case constraint }
        enum VariationCodingKey: CodingKey { case variation }
        enum ExternalCodingKeys: CodingKey { case color }
        enum ColorsCodingKeys: CodingKey { case key }

        static func decode(_ xml: XMLIndexerType) throws -> CollectionViewContentView {
            let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
                let stringValue: String = {
                    switch key {
                    case .isMisplaced: return "misplaced"
                    case .isAmbiguous: return "ambiguous"
                    case .isHidden: return "hidden"
                    default: return key.stringValue
                    }
                }()
                return MappedCodingKey(stringValue: stringValue)
            }
            let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
            let variationContainer = xml.container(keys: VariationCodingKey.self)
            let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
                .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

            return CollectionViewContentView(
                id:                                        container.attributeIfPresent(of: .id),
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
                alpha:                                     container.attributeIfPresent(of: .alpha)
            )
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color }
    enum ColorsCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> CollectionViewCell {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .isHidden: return "hidden"
                case ._subviews: return "subview"
                case .contentView:
                    if xml.childrenElements.contains(where: {$0.elementName == "collectionViewCellContentView"}) {
                        return "collectionViewCellContentView"
                    }
                    return "view"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

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
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
            verifyAmbiguity:                           container.attributeIfPresent(of: .verifyAmbiguity),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            _subviews:                                 container.childrenIfPresent(of: ._subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            reuseIdentifier:                           container.attributeIfPresent(of: .reuseIdentifier),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            isHidden:                                  container.attributeIfPresent(of: .isHidden),
            alpha:                                     container.attributeIfPresent(of: .alpha)
        )
    }
}

// MARK: - CollectionReusableView

public struct CollectionReusableView: IBDecodable, ViewProtocol, IBIdentifiable, IBReusable {

    public let id: String
    public let elementClass = "UICollectionReusableView"

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
    public let reuseIdentifier: String?
    public let backgroundColor: Color?
    public let tintColor: Color?
    public let isHidden: Bool?
    public let alpha: Float?
    
    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }
    enum ExternalCodingKeys: CodingKey { case color }
    enum ColorsCodingKeys: CodingKey { case key }

    static func decode(_ xml: XMLIndexerType) throws -> CollectionReusableView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                case .isHidden: return "hidden"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)
        let colorsContainer = xml.container(keys: ExternalCodingKeys.self)
            .nestedContainerIfPresent(of: .color, keys: ColorsCodingKeys.self)

        return CollectionReusableView(
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
            reuseIdentifier:                           container.attributeIfPresent(of: .reuseIdentifier),
            backgroundColor:                           colorsContainer?.withAttributeElement(.key, CodingKeys.backgroundColor.stringValue),
            tintColor:                                 colorsContainer?.withAttributeElement(.key, CodingKeys.tintColor.stringValue),
            isHidden:                                  container.attributeIfPresent(of: .isHidden),
            alpha:                                     container.attributeIfPresent(of: .alpha)
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

    static func decode(_ xml: XMLIndexerType) throws -> CollectionViewLayout {
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
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let scrollDirection: String? // vertical, horizontal
    public let automaticEstimatedItemSize: Bool?

    static func decode(_ xml: XMLIndexerType) throws -> CollectionViewFlowLayout {
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
            id:                         try container.attribute(of: .id),
            key:                        container.attributeIfPresent(of: .key),
            minimumLineSpacing:         container.attributeIfPresent(of: .minimumLineSpacing),
            minimumInteritemSpacing:    container.attributeIfPresent(of: .minimumInteritemSpacing),
            sizes:                      container.elementsIfPresent(of: .sizes),
            insets:                     container.elementsIfPresent(of: .insets),
            customClass:                container.attributeIfPresent(of: .customClass),
            customModule:               container.attributeIfPresent(of: .customModule),
            customModuleProvider:       container.attributeIfPresent(of: .customModuleProvider),
            scrollDirection:            container.attributeIfPresent(of: .scrollDirection),
            automaticEstimatedItemSize: container.attributeIfPresent(of: .automaticEstimatedItemSize)
        )
    }
}
