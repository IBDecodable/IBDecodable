//
//  NavigationController.swift
//  IBDecodable
//
//  Created by phimage on 02/04/2018.
//

import SWXMLHash

public struct NavigationController: XMLDecodable, ViewControllerProtocol {

    public let elementClass: String = "UINavgigationController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let navigationBar: NavigationBar?
    public var rootView: ViewProtocol? { return navigationBar }

    static func decode(_ xml: XMLIndexer) throws -> NavigationController {
        return NavigationController(
            id:                   try xml.attributeValue(of: "id"),
            customClass:          xml.attributeValue(of: "customClass"),
            customModule:         xml.attributeValue(of: "customModule"),
            customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier: xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes: xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:          xml.byKey("connections")?.children.flatMap(decodeValue),
            navigationBar:                 xml.byKey("navigationBar").flatMap(decodeValue)
        )
    }
}
