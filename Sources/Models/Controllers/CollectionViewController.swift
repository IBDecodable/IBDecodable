//
//  CollectionViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct CollectionViewController: XMLDecodable, KeyDecodable, ViewControllerProtocol {

    public let elementClass: String = "UICollectionViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let tabBarItem: TabBar.TabBarItem?
    public let collectionView: CollectionView?
    public var rootView: ViewProtocol? { return collectionView }
    public var clearsSelectionOnViewWillAppear: Bool

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewController {
        let container = xml.container(keys: CodingKeys.self)
        return CollectionViewController(
            id:                              try container.attribute(of: .id),
            customClass:                     container.attributeIfPresent(of: .customClass),
            customModule:                    container.attributeIfPresent(of: .customModule),
            customModuleProvider:            container.attributeIfPresent(of: .customModuleProvider),
            storyboardIdentifier:            container.attributeIfPresent(of: .storyboardIdentifier),
            layoutGuides:                    xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.compactMap(decodeValue),
            userDefinedRuntimeAttributes:    xml.byKey("userDefinedRuntimeAttributes")?.children.compactMap(decodeValue),
            connections:                     xml.byKey("connections")?.children.compactMap(decodeValue),
            tabBarItem:                      xml.byKey("tabBarItem").flatMap(decodeValue),
            collectionView:                  xml.byKey("collectionView").flatMap(decodeValue),
            clearsSelectionOnViewWillAppear: container.attributeIfPresent(of: .clearsSelectionOnViewWillAppear) ?? true
        )
    }
}
