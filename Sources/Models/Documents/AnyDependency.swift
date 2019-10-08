//
//  File.swift
//  
//
//  Created by Yannick Heinrich on 07.10.19.
//

import Foundation

// MARK: - DependencyProtocol
public protocol DependencyProtocol {
    var identifier: String { get }
}

// MARK: - AnyDependency
public struct AnyDependency: IBDecodable {
    public let dependency: DependencyProtocol

    init(_ dependency: DependencyProtocol) {
        self.dependency = dependency
    }

    public func encode(to encoder: Encoder) throws { fatalError() }
    static func decode(_ xml: XMLIndexerType) throws -> AnyDependency {

        guard let elementName = xml.elementName else {
            throw IBError.elementNotFound
        }

        switch elementName {
        case "deployment":
            return try AnyDependency(Deployment.decode(xml))
        case "plugIn":
            return try AnyDependency(PlugIn.decode(xml))
        case "capability":
            return try AnyDependency(Capability.decode(xml))
        default:
            throw IBError.unsupportedDependency
        }
    }
}

// MARK: - Deployment
public struct Deployment: IBDecodable, DependencyProtocol {
    public let identifier: String

    static func decode(_ xml: XMLIndexerType) throws -> Deployment {

        let container = xml.container(keys: CodingKeys.self)

        return Deployment(identifier: try container.attribute(of: .identifier))
    }
}

// MARK: - PlugIn
public struct PlugIn: IBDecodable, DependencyProtocol {
    public let identifier: String
    public let version: String

    static func decode(_ xml: XMLIndexerType) throws -> PlugIn {
        let container = xml.container(keys: CodingKeys.self)

        return PlugIn(identifier: try container.attribute(of: .identifier),
                      version: try container.attribute(of: .version))
    }
}

// MARK: - Capability
public struct Capability: IBDecodable, DependencyProtocol {
    public let name: String
    public let minToolsVersion: String

    static func decode(_ xml: XMLIndexerType) throws -> Capability {
        let container = xml.container(keys: CodingKeys.self)

        return Capability(name: try container.attribute(of: .name),
                      minToolsVersion: try container.attribute(of: .minToolsVersion))
    }

    public var identifier: String { return name }
}
