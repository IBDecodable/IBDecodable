//
//  CollectionViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct CollectionViewController: XMLDecodable, ViewControllerProtocol {

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
        return CollectionViewController(
            id:                              try xml.attributeValue(of: "id"),
            customClass:                     xml.attributeValue(of: "customClass"),
            customModule:                    xml.attributeValue(of: "customModule"),
            customModuleProvider:            xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier:            xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:                    xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes:    xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                     xml.byKey("connections")?.children.flatMap(decodeValue),
            tabBarItem:                      xml.byKey("tabBarItem").flatMap(decodeValue),
            collectionView:                  xml.byKey("collectionView").flatMap(decodeValue),
            clearsSelectionOnViewWillAppear: (try? xml.attributeValue(of: "clearsSelectionOnViewWillAppear")) ?? true
        )
    }
}
