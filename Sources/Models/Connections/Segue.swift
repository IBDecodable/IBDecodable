//
//  Segue.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct Segue: XMLDecodable, KeyDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let kind: Segue.Kind
    public let relationship: String?

    static func decode(_ xml: XMLIndexer) throws -> Segue {
        let container = xml.container(keys: CodingKeys.self)
        return Segue(
            id:            try container.attribute(of: .id),
            destination:   try container.attribute(of: .destination),
            kind:          try container.attribute(of: .kind),
            relationship:  container.attributeIfPresent(of: .relationship))
    }

    public enum Kind: XMLAttributeDecodable, KeyDecodable {
        case relationship, show, showDetail, presentation, embed, unwind, push
        case modal, popover, replace, custom(String)

        public func encode(to encoder: Encoder) throws { fatalError() }

        static func decode(_ attribute: XMLAttribute) throws -> Segue.Kind {
            switch attribute.text {
            case "relationship": return .relationship
            case "show": return .show
            case "showDetail": return .showDetail
            case "presentation": return .presentation
            case "embed": return .embed
            case "unwind": return .unwind
            case "push": return .push
            case "modal": return .modal
            case "popover": return .popover
            case "replace": return .replace
            default:
                return .custom(attribute.text)
            }
        }
    }

}
