//
//  Segue.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct Segue: IBDecodable, ConnectionProtocol {
    public let id: String
    public let destination: String
    public let kind: Segue.Kind
    public let relationship: String?
    public let identifier: String?
    public let destinationCreationSelector: String?
    public let modalPresentationStyle: ModalPresentationStyle?
    public let modalTransitionStyle: ModalTransitionStyle?

    static func decode(_ xml: XMLIndexerType) throws -> Segue {
        let container = xml.container(keys: CodingKeys.self)
        return Segue(
            id:            try container.attribute(of: .id),
            destination:   try container.attribute(of: .destination),
            kind:          try container.attribute(of: .kind),
            relationship:  container.attributeIfPresent(of: .relationship),
            identifier:    container.attributeIfPresent(of: .identifier),
            destinationCreationSelector:  container.attributeIfPresent(of: .destinationCreationSelector),
            modalPresentationStyle:       container.attributeIfPresent(of: .modalPresentationStyle),
            modalTransitionStyle:         container.attributeIfPresent(of: .modalTransitionStyle)
        )
    }

    public enum Kind: XMLAttributeDecodable, KeyDecodable, Equatable {
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

        public static func == (left: Kind, right: Kind) -> Bool {
            switch (left, right) {
            case (.relationship, .relationship):
                return true
            case (.show, .show):
                return true
            case (.showDetail, .showDetail):
                return true
            case (.presentation, .presentation):
                return true
            case (.embed, .embed):
                return true
            case (.unwind, .unwind):
                return true
            case (.push, .push):
                return true
            case (.modal, modal):
                return true
            case (.popover, .popover):
                return true
            case (.replace, .replace):
                return true
            case (.custom(let left), .custom(let right)):
                return left == right
            default:
                return false
            }
        }
    }
}
