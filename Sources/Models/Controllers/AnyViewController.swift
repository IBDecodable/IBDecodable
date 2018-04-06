//
//  AnyViewController.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewControllerProtocol

public protocol ViewControllerProtocol {
    var elementClass: String { get }
    var id: String { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var storyboardIdentifier: String? { get }
    var layoutGuides: [ViewControllerLayoutGuide]? { get }
    var userDefinedRuntimeAttributes: [UserDefinedRuntimeAttribute]? { get }
    var connections: [AnyConnection]? { get }
    var rootView: ViewProtocol? { get }
}

// MARK: - AnyViewController

public struct AnyViewController: XMLDecodable {

    public let viewController: ViewControllerProtocol

    init(_ viewController: ViewControllerProtocol) {
        self.viewController = viewController
    }

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

// MARK: - ViewControllerLayoutGuide

public struct ViewControllerLayoutGuide: XMLDecodable {
    public let id: String
    public let type: String

    static func decode(_ xml: XMLIndexer) throws -> ViewControllerLayoutGuide {
        return try ViewControllerLayoutGuide(
            id: xml.attributeValue(of: "id"),
            type: xml.attributeValue(of: "type")
        )
    }
}

// MARK: - ViewControllerPlaceholder

public struct ViewControllerPlaceholder: XMLDecodable {
    public let id: String
    public let storyboardName: String
    public let referencedIdentifier: String?
    public let sceneMemberID: String?

    static func decode(_ xml: XMLIndexer) throws -> ViewControllerPlaceholder {
        assert(xml.element?.name == "viewControllerPlaceholder")
        return ViewControllerPlaceholder(
            id: try xml.attributeValue(of: "id"),
            storyboardName: try xml.attributeValue(of: "storyboardName"),
            referencedIdentifier: xml.attributeValue(of: "referencedIdentifier"),
            sceneMemberID: xml.attributeValue(of: "sceneMemberID")
        )
    }
}
