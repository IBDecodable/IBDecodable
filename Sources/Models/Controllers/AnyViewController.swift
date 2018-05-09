//
//  AnyViewController.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewControllerProtocol

public protocol ViewControllerProtocol: IBIdentifiable, IBCustomClassable, IBUserLabelable {
    var elementClass: String { get }
    var id: String { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var userLabel: String? { get }
    var colorLabel: String? { get }
    var storyboardIdentifier: String? { get }
    var sceneMemberID: String? { get }
    var layoutGuides: [ViewControllerLayoutGuide]? { get }
    var userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]? { get }
    var connections: [AnyConnection]? { get }
    var keyCommands: [KeyCommand]? { get }
    /// The tab bar item that represents the view controller when added to a tab bar controller.
    var tabBarItem: TabBar.TabBarItem? { get }
    var rootView: ViewProtocol? { get }
}

// MARK: - AnyViewController

public struct AnyViewController: IBDecodable {

    public let viewController: ViewControllerProtocol

    init(_ viewController: ViewControllerProtocol) {
        self.viewController = viewController
    }

    public func encode(to encoder: Encoder) throws { fatalError() }

    static func decode(_ xml: XMLIndexer) throws -> AnyViewController {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "viewController": return try AnyViewController(ViewController.decode(xml))
        case "tableViewController": return try AnyViewController(TableViewController.decode(xml))
        case "collectionViewController": return try AnyViewController(CollectionViewController.decode(xml))
        case "navigationController": return try AnyViewController(NavigationController.decode(xml))
        case "tabBarController": return try AnyViewController(TabBarController.decode(xml))
        case "pageViewController": return try AnyViewController(PageViewController.decode(xml))
        case "splitViewController": return try AnyViewController(SplitViewController.decode(xml))
        case "avPlayerViewController": return try AnyViewController(AVPlayerViewController.decode(xml))
        case "glkViewController": return try AnyViewController(GLKViewController.decode(xml))
        default:
           throw IBError.unsupportedViewControllerClass(elementName)
        }
    }
}

extension AnyViewController: IBAny {
    public typealias NestedElement = ViewControllerProtocol
    public var nested: ViewControllerProtocol {
        return viewController
    }
}

// MARK: - ViewControllerLayoutGuide

public struct ViewControllerLayoutGuide: IBDecodable {
    public let id: String
    public let type: String

    static func decode(_ xml: XMLIndexer) throws -> ViewControllerLayoutGuide {
        let container = xml.container(keys: CodingKeys.self)
        return try ViewControllerLayoutGuide(
            id: container.attribute(of: .id),
            type: container.attribute(of: .type)
        )
    }
}

// MARK: - ViewControllerPlaceholder

public struct ViewControllerPlaceholder: IBDecodable {
    public let id: String
    public let storyboardName: String
    public let referencedIdentifier: String?
    public let sceneMemberID: String?

    static func decode(_ xml: XMLIndexer) throws -> ViewControllerPlaceholder {
        assert(xml.element?.name == "viewControllerPlaceholder")
        let container = xml.container(keys: CodingKeys.self)
        return ViewControllerPlaceholder(
            id: try container.attribute(of: .id),
            storyboardName: try container.attribute(of: .storyboardName),
            referencedIdentifier: container.attributeIfPresent(of: .referencedIdentifier),
            sceneMemberID: container.attributeIfPresent(of: .sceneMemberID)
        )
    }
}
