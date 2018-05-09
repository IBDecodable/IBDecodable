//
//  KeyCommand.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public struct KeyCommand: IBDecodable {

    public let input: String?
    public let modifierFlags: String?
    public let actionName: String?
    public let discoverabilityTitle: String?

    static func decode(_ xml: XMLIndexer) throws -> KeyCommand {
        let container = xml.container(keys: CodingKeys.self)
        return KeyCommand(
            input:                container.attributeIfPresent(of: .input),
            modifierFlags:        container.attributeIfPresent(of: .modifierFlags),
            actionName:           container.attributeIfPresent(of: .actionName),
            discoverabilityTitle: container.attributeIfPresent(of: .discoverabilityTitle)
        )
    }

}
