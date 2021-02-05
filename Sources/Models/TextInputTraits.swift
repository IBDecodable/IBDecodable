//
//  File.swift
//  
//
//  Created by Ibrahim Hassan on 31/01/21.
//

public struct TextInputTraits: IBDecodable, IBKeyable {
    public let key: String?
    public let autocorrectionType: Bool?
    public let spellCheckingType: Bool?
    public let keyboardType: String?
    public let keyboardAppearance: String?
    public let returnKeyType: String?
    public let enablesReturnKeyAutomatically: Bool?
    public let smartDashesType: Bool?
    public let smartInsertDeleteType: Bool?
    public let smartQuotesType: Bool?
    public let textContentType: String?
    public let autocapitalizationType: String?

    static func decode(_ xml: XMLIndexerType) throws -> TextInputTraits {
        let container = xml.container(keys: CodingKeys.self)
        return TextInputTraits(
            key: container.attributeIfPresent(of: .key),
            autocorrectionType: container.attributeIfPresent(of: .autocorrectionType),
            spellCheckingType: container.attributeIfPresent(of: .spellCheckingType),
            keyboardType: container.attributeIfPresent(of: .keyboardType),
            keyboardAppearance: container.attributeIfPresent(of: .keyboardAppearance),
            returnKeyType: container.attributeIfPresent(of: .returnKeyType),
            enablesReturnKeyAutomatically: container.attributeIfPresent(of: .enablesReturnKeyAutomatically),
            smartDashesType: container.attributeIfPresent(of: .smartDashesType),
            smartInsertDeleteType: container.attributeIfPresent(of: .smartInsertDeleteType),
            smartQuotesType: container.attributeIfPresent(of: .smartDashesType),
            textContentType: container.attributeIfPresent(of: .textContentType),
            autocapitalizationType: container.attributeIfPresent(of: .autocapitalizationType)
        )
    }
}
