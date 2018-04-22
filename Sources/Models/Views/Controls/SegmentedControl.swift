//
//  SegmentedControl.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct SegmentedControl: XMLDecodable, KeyDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UISegmentedControl"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let segmentControlStyle: String?
    public let segments: [Segment]
    public let selectedSegmentIndex: Int?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    public struct Segment: XMLDecodable, KeyDecodable {
        public let title: String

        static func decode(_ xml: XMLIndexer) throws -> SegmentedControl.Segment {
            let container = xml.container(keys: CodingKeys.self)
            return try Segment(title: container.attribute(of: .title))
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> SegmentedControl {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        
        return SegmentedControl(
            id:                                         try container.attribute(of: .id),
            autoresizingMask:                           container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                              container.attributeIfPresent(of: .clipsSubviews),
            constraints:                                xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                 container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                                container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                   container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                                container.attributeIfPresent(of: .customClass),
            customModule:                               container.attributeIfPresent(of: .customModule),
            isMisplaced:                                container.attributeIfPresent(of: .isMisplaced),
            opaque:                                     container.attributeIfPresent(of: .opaque),
            rect:                                       try decodeValue(xml.byKey("rect")),
            segmentControlStyle:                        container.attributeIfPresent(of: .segmentControlStyle),
            segments:                                   try xml.byKey("segments").byKey("segment").all.map(decodeValue),
            selectedSegmentIndex:                       container.attributeIfPresent(of: .selectedSegmentIndex),
            subviews:                                   xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints:  container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                     container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              xml.byKey("userDefinedRuntimeAttributes")?.children.flatMap(decodeValue),
            connections:                               xml.byKey("connections")?.children.flatMap(decodeValue)
        )
    }

}
