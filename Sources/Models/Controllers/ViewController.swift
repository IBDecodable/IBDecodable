//
//  ViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct ViewController: XMLDecodable, ViewControllerProtocol {

    public let elementClass: String = "UIViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let view: View?
    public var rootView: ViewProtocol? { return view }

    static func decode(_ xml: XMLIndexer) throws -> ViewController {
        return ViewController(
            id:                   try xml.attributeValue(of: "id"),
            customClass:          xml.attributeValue(of: "customClass"),
            customModule:         xml.attributeValue(of: "customModule"),
            customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier: xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes: xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:          xml.byKey("connections")?.children.flatMap(decodeValue),
            view:                 xml.byKey("view").flatMap(decodeValue)
        )
    }
}
