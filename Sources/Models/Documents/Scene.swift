//
//  Scene.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public struct Scene: IBDecodable {

    public let id: String
    public let viewController: AnyViewController?
    public let viewControllerPlaceholder: ViewControllerPlaceholder?
    public let canvasLocation: Point?
    public let placeholders: [Placeholder]?
    public let customObjects: [CustomObject]?
    public let customViews: [AnyView]?
    public let searchDisplayControllers: [SearchDisplayController]?
    public let exit: Exit?

    enum ExternalCodingKeys: CodingKey { case objects }
    enum ObjectsCodingKeys: CodingKey { case placeholder, customObject, searchDisplayController, viewControllerPlaceholder }

    static func decode(_ xml: XMLIndexerType) throws -> Scene {
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
            viewControllerPlaceholder: objectsContainer?.elementIfPresent(of: .viewControllerPlaceholder),
            canvasLocation:            container.elementIfPresent(of: .canvasLocation),
            placeholders:              objectsContainer?.elementsIfPresent(of: .placeholder),
            customObjects:             objectsContainer?.elementsIfPresent(of: .customObject),
            customViews:               externalContainer.childrenIfPresent(of: .objects),
            searchDisplayControllers:  objectsContainer?.elementsIfPresent(of: .searchDisplayController),
            exit:                      container.elementIfPresent(of: .exit)
        )
    }

}
