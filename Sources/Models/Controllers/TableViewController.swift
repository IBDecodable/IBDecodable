//
//  TableViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TableViewController: XMLDecodable, KeyDecodable, ViewControllerProtocol {

    public let elementClass: String = "UITableViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let tabBarItem: TabBar.TabBarItem?
    public let tableView: TableView?
    public var rootView: ViewProtocol? { return tableView }
    public var clearsSelectionOnViewWillAppear: Bool?

    static func decode(_ xml: XMLIndexer) throws -> TableViewController {
        let container = xml.container(keys: CodingKeys.self)
        return TableViewController(
            id:                              try container.attribute(of: .id),
            customClass:                     container.attributeIfPresent(of: .customClass),
            customModule:                    container.attributeIfPresent(of: .customModule),
            customModuleProvider:            container.attributeIfPresent(of: .customModuleProvider),
            storyboardIdentifier:            container.attributeIfPresent(of: .storyboardIdentifier),
            layoutGuides:                    xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.compactMap(decodeValue),
            userDefinedRuntimeAttributes:    xml.byKey("userDefinedRuntimeAttributes")?.children.compactMap(decodeValue),
            connections:                     xml.byKey("connections")?.children.compactMap(decodeValue),
            tabBarItem:                      xml.byKey("tabBarItem").flatMap(decodeValue),
            tableView:                       xml.byKey("tableView").flatMap(decodeValue),
            clearsSelectionOnViewWillAppear: (try? container.attributeIfPresent(of: .clearsSelectionOnViewWillAppear)) ?? true
        )
    }
}
