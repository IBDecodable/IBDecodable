//
//  TabBar.swift
//  IBDecodable
//
//  Created by phimage on 05/04/2018.
//

import SWXMLHash

public struct TabBar: IBDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITabBar"

    public let key: String?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let items: [TabBarItem]?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]?
    public let connections: [AnyConnection]?

    public struct TabBarItem: IBDecodable, IBKeyable {
        public let id: String
        public let key: String?
        public let style: String?
        public let systemItem: String?
        public let title: String?

        static func decode(_ xml: XMLIndexer) throws -> TabBar.TabBarItem {
            let container = xml.container(keys: CodingKeys.self)
            return TabBarItem(
                id:         try container.attribute(of: .id),
                key:      container.attributeIfPresent(of: .key),
                style:      container.attributeIfPresent(of: .style),
                systemItem: container.attributeIfPresent(of: .systemItem),
                title:      container.attributeIfPresent(of: .title)
            )
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum TabBarItemsCodingKeys: CodingKey { case tabBarItem }

    static func decode(_ xml: XMLIndexer) throws -> TabBar {
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
        let tabBarItemsContainer = container.nestedContainerIfPresent(of: .items, keys: TabBarItemsCodingKeys.self)

        return TabBar(
            id:                                        try container.attribute(of: .id),
            key:                                       container.attributeIfPresent(of: .key),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            customModuleProvider:                      container.attributeIfPresent(of: .customModuleProvider),
            items:                                     tabBarItemsContainer?.elementsIfPresent(of: .tabBarItem),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      try container.element(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled),
            userDefinedRuntimeAttributes:              container.childrenIfPresent(of: .userDefinedRuntimeAttributes),
            connections:                               container.childrenIfPresent(of: .connections)
        )
    }
}
