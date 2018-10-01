//
//  MapView.swift
//  IBDecodable
//
//  Created by phimage on 01/04/2018.
//

import SWXMLHash

public struct MapView: IBDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "MKMapView"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let userLabel: String?
    public let colorLabel: String?
    public let isMisplaced: Bool?
    public let isAmbiguous: Bool?
    public let opaque: Bool?
    public let rect: Rect?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let viewLayoutGuide: LayoutGuide?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?
    public let variations: [Variation]?
    public let mapType: String?
    public let multipleTouchEnabled: Bool?
    public let showsTraffic: Bool?
    public let scrollEnabled: Bool?
    public let appearanceType: String?
    public let verticalHuggingPriority: Int?
    public let showsCompass: Bool?
    public let showsPointsOfInterest: Bool?
    public let restorationIdentifier: String?
    public let showsUserLocation: Bool?
    public let showsScale: Bool?
    public let showsBuildings: Bool?
    public let pitchEnabled: Bool?
    public let rotateEnabled: Bool?
    public let zoomEnabled: Bool?
    public let verticalCompressionResistancePriority: String?

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum VariationCodingKey: CodingKey { case variation }

    static func decode(_ xml: XMLIndexerType) throws -> MapView {
        let container = xml.container(keys: MappedCodingKey.self).map { (key: CodingKeys) in
            let stringValue: String = {
                switch key {
                case .isMisplaced: return "misplaced"
                case .isAmbiguous: return "ambiguous"
                default: return key.stringValue
                }
            }()
            return MappedCodingKey(stringValue: stringValue)
        }
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let variationContainer = xml.container(keys: VariationCodingKey.self)

        return MapView(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            userLabel:                                 container.attributeIfPresent(of: .userLabel),
            colorLabel:                                container.attributeIfPresent(of: .colorLabel),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            isAmbiguous:                               container.attributeIfPresent(of: .isAmbiguous),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.elementIfPresent(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            viewLayoutGuide:                           container.elementIfPresent(of: .viewLayoutGuide),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections),
            variations:                                variationContainer.elementsIfPresent(of: .variation),
            mapType:                                   container.attributeIfPresent(of: .mapType),
            multipleTouchEnabled:                      container.attributeIfPresent(of: .multipleTouchEnabled),
            showsTraffic:                              container.attributeIfPresent(of: .showsTraffic),
            scrollEnabled:                             container.attributeIfPresent(of: .scrollEnabled),
            appearanceType:                            container.attributeIfPresent(of: .appearanceType),
            verticalHuggingPriority:                   container.attributeIfPresent(of: .verticalHuggingPriority),
            showsCompass:                              container.attributeIfPresent(of: .showsCompass),
            showsPointsOfInterest:                     container.attributeIfPresent(of: .showsPointsOfInterest),
            restorationIdentifier:                     container.attributeIfPresent(of: .restorationIdentifier),
            showsUserLocation:                         container.attributeIfPresent(of: .showsUserLocation),
            showsScale:                                container.attributeIfPresent(of: .showsScale),
            showsBuildings:                            container.attributeIfPresent(of: .showsBuildings),
            pitchEnabled:                              container.attributeIfPresent(of: .pitchEnabled),
            rotateEnabled:                             container.attributeIfPresent(of: .rotateEnabled),
            zoomEnabled:                               container.attributeIfPresent(of: .zoomEnabled),
            verticalCompressionResistancePriority:     container.attributeIfPresent(of: .verticalCompressionResistancePriority)
        )
    }
}
