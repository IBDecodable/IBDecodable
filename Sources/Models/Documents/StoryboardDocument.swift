//
//  StoryboardDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - StoryboardDocument

public struct StoryboardDocument: IBDecodable {
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

    enum ScenesCodingKeys: CodingKey { case scene }

    static func decode(_ xml: XMLIndexer) throws -> StoryboardDocument {
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
            connections:           findConnections(in: xml)
        )
    }
}

// MARK: - Scene

public struct Scene: IBDecodable {

    public let id: String
    public let viewController: AnyViewController?
    public let viewControllerPlaceholder: ViewControllerPlaceholder?
    public let canvasLocation: Point?
    public let placeholders: [Placeholder]?

    enum ExternalCodingKeys: CodingKey { case objects }
    enum ObjectsCodingKeys: CodingKey { case placeholder }

    static func decode(_ xml: XMLIndexer) throws -> Scene {
        let externalContainer = xml.container(keys: ExternalCodingKeys.self)
        let objectsContainer = externalContainer.nestedContainerIfPresent(of: .objects, keys: ObjectsCodingKeys.self)
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .id: return "sceneID"
                case .canvasLocation: return "point"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        return Scene(
            id:                        try container.attribute(of: .id),
            viewController:            externalContainer.childrenIfPresent(of: .objects)?.first,
            viewControllerPlaceholder: container.elementIfPresent(of: .viewControllerPlaceholder),
            canvasLocation:            container.elementIfPresent(of: .canvasLocation),
            placeholders:              objectsContainer?.elementsIfPresent(of: .placeholder)
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
