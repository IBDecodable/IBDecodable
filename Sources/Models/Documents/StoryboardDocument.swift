//
//  StoryboardDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - StoryboardDocument

public struct StoryboardDocument: XMLDecodable {
    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: String
    public let propertyAccessControl: String?
    public let useAutolayout: Bool?
    public let useTraitCollections: Bool?
    public let useSafeAreas: Bool?
    public let colorMatched: Bool?
    public let initialViewController: String?
    public let launchScreen: Bool
    public let device: Device?
    public let scenes: [Scene]?
    public let resources: [AnyResource]?
    public let connections: [AnyConnection]?

    static func decode(_ xml: XMLIndexer) throws -> StoryboardDocument {
        return StoryboardDocument(
            type:                  try xml.attributeValue(of: "type"),
            version:               try xml.attributeValue(of: "version"),
            toolsVersion:          try xml.attributeValue(of: "toolsVersion"),
            targetRuntime:         try xml.attributeValue(of: "targetRuntime"),
            propertyAccessControl: xml.attributeValue(of: "propertyAccessControl"),
            useAutolayout:         xml.attributeValue(of: "useAutolayout"),
            useTraitCollections:   xml.attributeValue(of: "useTraitCollections"),
            useSafeAreas:          xml.attributeValue(of: "useSafeAreas"),
            colorMatched:          xml.attributeValue(of: "colorMatched"),
            initialViewController: xml.attributeValue(of: "initialViewController"),
            launchScreen:          xml.attributeValue(of: "launchScreen") ?? false,
            device:                xml.byKey("device").flatMap(decodeValue),
            scenes:                xml.byKey("scenes")?.byKey("scene")?.all.flatMap(decodeValue),
            resources:             xml.byKey("resources")?.children.flatMap(decodeValue),
            connections:           findConnections(in: xml)
        )
    }
}

// MARK: - Scene

public struct Scene: XMLDecodable {

    public let id: String
    public let viewController: AnyViewController?
    public let viewControllerPlaceholder: ViewControllerPlaceholder?
    public let canvasLocation: Point?
    public let placeholders: [Placeholder]?

    static func decode(_ xml: XMLIndexer) throws -> Scene {
        let objects: XMLIndexer? = xml.byKey("objects")
        return Scene(
            id:                        try xml.attributeValue(of: "sceneID"),
            viewController:            objects?.children.first.flatMap(decodeValue),
            viewControllerPlaceholder: objects?.byKey("viewControllerPlaceholder").flatMap(decodeValue),
            canvasLocation:            xml.byKey("point").flatMap(decodeValue),
            placeholders:              objects?.byKey("placeholder")?.all.flatMap(decodeValue)
        )
    }

}


// MARK: - Connection
// FIXME: This implementation is temporary

func findConnections(in xml: XMLIndexer) -> [AnyConnection] {
    guard let connections: XMLIndexer = xml.byKey("connections") else {
        return xml.children.flatMap(findConnections)
    }
    let parsedConnections = try? connections.children.map(AnyConnection.decode)
    return (parsedConnections ?? []) + xml.children.flatMap(findConnections)
}
