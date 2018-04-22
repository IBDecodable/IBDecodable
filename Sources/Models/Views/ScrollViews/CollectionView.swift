//
//  CollectionView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - CollectionView

public struct CollectionView: XMLDecodable, KeyDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UICollectionView"

    public let alwaysBounceHorizontal: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let cells: [CollectionViewCell]?
    public let layout: CollectionViewLayout?
    public let flowLayout: CollectionViewFlowLayout?

    static func decode(_ xml: XMLIndexer) throws -> CollectionView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return CollectionView(
            id:                                        try container.attribute(of: .id),
            alwaysBounceHorizontal:                    container.attributeIfPresent(of: .alwaysBounceHorizontal),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.compactMap(decodeValue),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.compactMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.compactMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.compactMap(decodeValue),
            cells:                                     xml.byKey("cells")?.children.compactMap(decodeValue),
            layout:                                    xml.byKey("collectionViewLayout").flatMap(decodeValue),
            flowLayout:                                xml.byKey("collectionViewFlowLayout").flatMap(decodeValue)
        )
    }
}

// MARK: - CollectionViewCell

public struct CollectionViewCell: XMLDecodable, KeyDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UICollectionViewCell"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: View
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
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

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewCell {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }

        return CollectionViewCell(
            id:                                        try container.attribute(of: .id),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.compactMap(decodeValue),
            contentView:                               try decodeValue(xml.byKey("view")),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try decodeValue(xml.byKey("rect")),
            _subviews:                                 xml.byKey("subviews")?.children.compactMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.compactMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.compactMap(decodeValue)
        )
    }
}

// MARK: - CollectionViewLayout

public struct CollectionViewLayout: XMLDecodable, KeyDecodable {

    public let id: String
    public let key: String?
    public let customClass: String?
    public let customModule: String?

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewLayout {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .key: return "contentMode"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        return CollectionViewLayout(
            id:                       try container.attribute(of: .id),
            key:                      container.attributeIfPresent(of: .key),
            customClass:              container.attributeIfPresent(of: .customClass),
            customModule:             container.attributeIfPresent(of: .customModule)
        )
    }
}

// MARK: - CollectionViewFlowLayout

public struct CollectionViewFlowLayout: XMLDecodable, KeyDecodable {

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
            sizes:                     xml.byKey("size")?.all.compactMap(decodeValue),
            insets:                     xml.byKey("inset")?.all.compactMap(decodeValue)
        )
    }
}
