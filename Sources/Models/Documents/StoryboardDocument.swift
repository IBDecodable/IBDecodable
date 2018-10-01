//
//  StoryboardDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - StoryboardDocument

public struct StoryboardDocument: IBDecodable, InterfaceBuilderDocument {

    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: TargetRuntime
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
    public let classes: [IBClass]?

    enum ScenesCodingKeys: CodingKey { case scene }

    static func decode(_ xml: XMLIndexerType) throws -> StoryboardDocument {
        let container = xml.container(keys: CodingKeys.self)
        let scenesContainer = container.nestedContainerIfPresent(of: .scenes, keys: ScenesCodingKeys.self)
        return StoryboardDocument(
            type:                  try container.attribute(of: .type),
            version:               try container.attribute(of: .version),
            toolsVersion:          try container.attribute(of: .toolsVersion),
            targetRuntime:         try container.attribute(of: .targetRuntime),
            propertyAccessControl: container.attributeIfPresent(of: .propertyAccessControl),
            useAutolayout:         container.attributeIfPresent(of: .useAutolayout),
            useTraitCollections:   container.attributeIfPresent(of: .useTraitCollections),
            useSafeAreas:          container.attributeIfPresent(of: .useSafeAreas),
            colorMatched:          container.attributeIfPresent(of: .colorMatched),
            initialViewController: container.attributeIfPresent(of: .initialViewController),
            launchScreen:          container.attributeIfPresent(of: .launchScreen) ?? false,
            device:                container.elementIfPresent(of: .device),
            scenes:                scenesContainer?.elementsIfPresent(of: .scene),
            resources:             container.childrenIfPresent(of: .resources),
            classes:               container.childrenIfPresent(of: .classes)
        )
    }

    public var ibType: IBType {
        return .storyboard
    }

}
