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
    public let placeholders: [Placeholder]?
    public let resources: [AnyResource]?

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
            placeholders:          xml.byKey("objects")?.byKey("placeholder")?.all.flatMap(decodeValue),
            resources:             xml.byKey("resources")?.children.flatMap(decodeValue)
        )
    }
}

// MARK: - Device

public struct Device: XMLDecodable {
    public let id: String
    public let orientation: String?
    public let adaptation: String?

    static func decode(_ xml: XMLIndexer) throws -> Device {
        return Device(
            id:          try xml.attributeValue(of: "id"),
            orientation: xml.attributeValue(of: "orientation"),
            adaptation:  xml.byKey("adaptation")?.attributeValue(of: "id")
        )
    }
}

// MARK: - Scene

public struct Scene: XMLDecodable {
    public let id: String
    public let viewController: AnyViewController?
    public let canvasLocation: Point?

    static func decode(_ xml: XMLIndexer) throws -> Scene {
        return Scene(
            id:             try xml.attributeValue(of: "sceneID"),
            viewController: xml.byKey("objects")?.children.first.flatMap(decodeValue),
            canvasLocation: xml.byKey("point").flatMap(decodeValue)
        )
    }
}

// MARK: - Placeholder

public struct Placeholder: XMLDecodable {
    public let id: String
    public let placeholderIdentifier: String
    public let userLabel: String?
    public let sceneMemberID: String?
    public let customClass: String?

    static func decode(_ xml: XMLIndexer) throws -> Placeholder {
        return Placeholder(
            id:                    try xml.attributeValue(of: "id"),
            placeholderIdentifier: try xml.attributeValue(of: "placeholderIdentifier"),
            userLabel:             xml.attributeValue(of: "userLabel"),
            sceneMemberID:         xml.attributeValue(of: "userLabel"),
            customClass:           xml.attributeValue(of: "customClass")
        )
    }
}
