//
//  AVPlayerViewController.swift
//  IBDecodable
//
//  Created by phimage on 04/04/2018.
//

import SWXMLHash

public struct AVPlayerViewController: XMLDecodable, ViewControllerProtocol {

    public let elementClass: String = "AVPlayerViewController"
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let view: AnyView?
    public var rootView: ViewProtocol? { return view?.view }

    static func decode(_ xml: XMLIndexer) throws -> AVPlayerViewController {
        return AVPlayerViewController.init(
            id:                   try xml.attributeValue(of: "id"),
            customClass:          xml.attributeValue(of: "customClass"),
            customModule:         xml.attributeValue(of: "customModule"),
            customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier: xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            userDefinedRuntimeAttributes: xml.byKey("userDefinedRuntimeAttributes")?.byKey("userDefinedRuntimeAttribute")?.all.flatMap(decodeValue),
            view:                 xml.children.first.flatMap(decodeValue)
        )
    }
}
