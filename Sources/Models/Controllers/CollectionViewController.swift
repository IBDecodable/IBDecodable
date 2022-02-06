//
//  CollectionViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct CollectionViewController: IBDecodable, ViewControllerProtocol {

    public let elementClass: String = "UICollectionViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public var storyboardIdentifier: String?
    public var sceneMemberID: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let keyCommands: [KeyCommand]?
    public let tabBarItem: TabBar.TabBarItem?
    public let collectionView: CollectionView?
    public var rootView: ViewProtocol? { return collectionView }
    public let clearsSelectionOnViewWillAppear: Bool
    public let size: [Size]?
    public let hidesBottomBarWhenPushed: Bool?

    enum LayoutGuidesCodingKeys: CodingKey { case viewControllerLayoutGuide }

    static func decode(_ xml: XMLIndexerType) throws -> CollectionViewController {
        let container = xml.container(keys: CodingKeys.self)
        let layoutGuidesContainer = container.nestedContainerIfPresent(of: .layoutGuides, keys: LayoutGuidesCodingKeys.self)
        return CollectionViewController(
            id:                              try container.attribute(of: .id),
            customClass:                     container.attributeIfPresent(of: .customClass),
            customModule:                    container.attributeIfPresent(of: .customModule),
            customModuleProvider:            container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                       container.attributeIfPresent(of: .userLabel),
            colorLabel:                      container.attributeIfPresent(of: .colorLabel),
            storyboardIdentifier:            container.attributeIfPresent(of: .storyboardIdentifier),
            sceneMemberID:                   container.attributeIfPresent(of: .sceneMemberID),
            layoutGuides:                    layoutGuidesContainer?.elementsIfPresent(of: .viewControllerLayoutGuide),
            userDefinedRuntimeAttributes:    container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                     container.childrenIfPresent(of: .connections),
            keyCommands:                     container.childrenIfPresent(of: .keyCommands),
            tabBarItem:                      container.elementIfPresent(of: .tabBarItem),
            collectionView:                  container.elementIfPresent(of: .collectionView),
            clearsSelectionOnViewWillAppear: container.attributeIfPresent(of: .clearsSelectionOnViewWillAppear) ?? true,
            size:                            container.elementsIfPresent(of: .size),
            hidesBottomBarWhenPushed:     container.attributeIfPresent(of: .hidesBottomBarWhenPushed)
        )
    }
}
