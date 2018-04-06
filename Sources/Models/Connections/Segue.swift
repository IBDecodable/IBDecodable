//
//  Segue.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct Segue: XMLDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let kind: Segue.Kind
    public let relationship: String?

    static func decode(_ xml: XMLIndexer) throws -> Segue {
        return Segue(
            id:            try xml.attributeValue(of: "id"),
            destination:   try xml.attributeValue(of: "destination"),
            kind:          try xml.attributeValue(of: "kind"),
            relationship:  xml.attributeValue(of: "relationship"))
    }

    public enum Kind: XMLAttributeDecodable {
        case relationship, show, showDetail, presentation, embed, unwind, push
        case modal, popover, replace, custom(String)

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
