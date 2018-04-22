//
//  AVPlayerViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct AVPlayerViewController: XMLDecodable, KeyDecodable, ViewControllerProtocol {

    public let elementClass: String = "AVPlayerViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let tabBarItem: TabBar.TabBarItem?
    public let view: AnyView?
    public var rootView: ViewProtocol? { return view?.view }
    public var videoGravity: String?

    static func decode(_ xml: XMLIndexer) throws -> AVPlayerViewController {
        let container = xml.container(keys: CodingKeys.self)
        return AVPlayerViewController(
            id:                   try container.attribute(of: .id),
            customClass:          container.attributeIfPresent(of: .customClass),
            customModule:         container.attributeIfPresent(of: .customModule),
            customModuleProvider: container.attributeIfPresent(of: .customModuleProvider),
            storyboardIdentifier: container.attributeIfPresent(of: .storyboardIdentifier),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes: xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:          xml.byKey("connections")?.children.flatMap(decodeValue),
            tabBarItem:           container.elementIfPresent(of: .tabBarItem),
            view:                 xml.children.first.flatMap(decodeValue),
            videoGravity:         container.attributeIfPresent(of: .videoGravity)
        )
    }
}
