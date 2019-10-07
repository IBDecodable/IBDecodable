//
//  XibDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct XibDocument: IBDecodable, InterfaceBuilderDocument {

    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: TargetRuntime
    public let propertyAccessControl: String?
    public let useAutolayout: Bool?
    public let useTraitCollections: Bool?
    public let useSafeAreas: Bool?
    public let colorMatched: Bool?
    public let device: Device?
    public let views: [AnyView]?
    public let resources: [AnyResource]?
    public let placeholders: [Placeholder]?
    public let dependencies: [AnyDependency]?
    
    enum ExternalCodingKeys: CodingKey { case objects }
    enum ObjectsCodingKeys: CodingKey { case placeholder }

    static func decode(_ xml: XMLIndexerType) throws -> XibDocument {
        let container = xml.container(keys: CodingKeys.self)
        let externalContainer = xml.container(keys: ExternalCodingKeys.self)
        let objectsContainer = externalContainer.nestedContainerIfPresent(of: .objects, keys: ObjectsCodingKeys.self)
        return XibDocument(
            type:                  try container.attribute(of: .type),
            version:               try container.attribute(of: .version),
            toolsVersion:          try container.attribute(of: .toolsVersion),
            targetRuntime:         try container.attribute(of: .targetRuntime),
            propertyAccessControl: container.attributeIfPresent(of: .propertyAccessControl),
            useAutolayout:         container.attributeIfPresent(of: .useAutolayout),
            useTraitCollections:   container.attributeIfPresent(of: .useTraitCollections),
            useSafeAreas:          container.attributeIfPresent(of: .useSafeAreas),
            colorMatched:          container.attributeIfPresent(of: .colorMatched),
            device:                container.elementIfPresent(of: .device),
            views:                 externalContainer.childrenIfPresent(of: .objects),
            resources:             container.childrenIfPresent(of: .resources),
            placeholders:          objectsContainer?.elementsIfPresent(of: .placeholder),
            dependencies:          container.childrenIfPresent(of: .dependencies)
        )
    }

    public var ibType: IBType {
        return .xib
    }

}
