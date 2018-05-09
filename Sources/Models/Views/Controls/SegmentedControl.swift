//
//  SegmentedControl.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct SegmentedControl: IBDecodable, ViewProtocol {
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

    public struct Segment: IBDecodable {
        public let title: String

        static func decode(_ xml: XMLIndexer) throws -> SegmentedControl.Segment {
            let container = xml.container(keys: CodingKeys.self)
            return try Segment(title: container.attribute(of: .title))
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum SegmentsCodingKeys: CodingKey { case segment }

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
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let segmentsContainer = container.nestedContainerIfPresent(of: .segments, keys: SegmentsCodingKeys.self)

        return SegmentedControl(
            id:                                         try container.attribute(of: .id),
            autoresizingMask:                           container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                              container.attributeIfPresent(of: .clipsSubviews),
            constraints:                                constraintsContainer?.elementsIfPresent(of: .constraint),
            contentHorizontalAlignment:                 container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                                container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                   container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                                container.attributeIfPresent(of: .customClass),
            customModule:                               container.attributeIfPresent(of: .customModule),
            isMisplaced:                                container.attributeIfPresent(of: .isMisplaced),
            opaque:                                     container.attributeIfPresent(of: .opaque),
            rect:                                       try container.element(of: .rect),
            segmentControlStyle:                        container.attributeIfPresent(of: .segmentControlStyle),
            segments:                                   try segmentsContainer?.elements(of: .segment) ?? [],
            selectedSegmentIndex:                       container.attributeIfPresent(of: .selectedSegmentIndex),
            subviews:                                   container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints:  container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                     container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections)
        )
    }

}
