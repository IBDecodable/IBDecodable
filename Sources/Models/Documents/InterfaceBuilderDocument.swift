//
//  InterfaceBuilderDocument.swift
//  IBDecodableTests
//
//  Created by phimage on 11/05/2018.
//

public protocol InterfaceBuilderDocument {
    var ibType: IBType { get }
    var type: String {get}
    var version: String {get}
    var toolsVersion: String {get}
    var targetRuntime: TargetRuntime {get}
    var propertyAccessControl: String? {get}
    var useAutolayout: Bool? {get}
    var useTraitCollections: Bool? {get}
    var useSafeAreas: Bool? {get}
    var colorMatched: Bool? {get}
    var device: Device? {get}
    var dependencies: [AnyDependency]? { get }
}
