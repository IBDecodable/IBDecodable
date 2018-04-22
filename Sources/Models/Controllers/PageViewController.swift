//
//  PageViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct PageViewController: XMLDecodable, KeyDecodable, ViewControllerProtocol {

    public let elementClass: String = "UIPageViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let tabBarItem: TabBar.TabBarItem?
    public let view: View?
    public var rootView: ViewProtocol? { return view }

    static func decode(_ xml: XMLIndexer) throws -> PageViewController {
        let container = xml.container(keys: CodingKeys.self)
        return PageViewController(
            id:                   try container.attribute(of: .id),
            customClass:          container.attributeIfPresent(of: .customClass),
            customModule:         container.attributeIfPresent(of: .customModule),
            customModuleProvider: container.attributeIfPresent(of: .customModuleProvider),
            storyboardIdentifier: container.attributeIfPresent(of: .storyboardIdentifier),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes: xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:          xml.byKey("connections")?.children.flatMap(decodeValue),
            tabBarItem:           xml.byKey("tabBarItem").flatMap(decodeValue),
            view:                 xml.byKey("view").flatMap(decodeValue)
        )
    }
}
