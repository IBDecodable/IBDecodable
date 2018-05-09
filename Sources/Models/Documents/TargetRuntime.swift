//
//  TargetRuntime.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import SWXMLHash

public enum TargetRuntime: String, XMLAttributeDecodable, KeyDecodable {
    case iOSCocoaTouch = "iOS.CocoaTouch"
    case iOSCocoaTouchIPad = "iOS.CocoaTouch.iPad"
    case macOSXCocoa = "MacOSX.Cocoa"
    case appleTV = "AppleTV"

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ attribute: XMLAttribute) throws -> TargetRuntime {
        guard let targetRuntime = TargetRuntime(rawValue: attribute.text) else {
            throw XMLDeserializationError.implementationIsMissing(method: attribute.text)
        }
        return targetRuntime
    }

    var os: OS {
        return OS(targetRuntime: self)
    }

}

public enum OS: String {
    case iOS, macOS, tvOS

    static let all = [iOS, macOS, tvOS]

    public init(targetRuntime: TargetRuntime) {
        switch targetRuntime {
        case .iOSCocoaTouch, .iOSCocoaTouchIPad:
            self = .iOS
        case .macOSXCocoa:
            self = .macOS
        case .appleTV:
            self = .tvOS
        }
    }
}
