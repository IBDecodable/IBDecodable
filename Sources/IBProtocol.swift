//
//  IBProtocol.swift
//  IBDecodable
//
//  Created by phimage on 09/05/2018.
//

import Foundation

/// Common protocol for decoded elements.
protocol IBDecodable: XMLDecodable, KeyDecodable, IBElement {}

/// Any element with an `id`.
public protocol IBIdentifiable: IBElement {
    var id: String { get }
}

/// Any element with an optional `key`.
public protocol IBKeyable: IBElement {
    var key: String? { get }
}

/// Any element with `reuseIdentifier`
public protocol IBReusable: IBElement {
    var reuseIdentifier: String? { get }
}

/// Any element that could be created with custom class.
public protocol IBCustomClassable: IBElement {
    var customClass: String? { get }
    var customModule: String? { get}
    var customModuleProvider: String? { get}
}

/// Any element that could be labeled by user.
public protocol IBUserLabelable: IBElement {
    var userLabel: String? { get }
    var colorLabel: String? { get }
    // TODO add ?: var userComments: AttributedString?
}

/// Any element that could contains connections.
public protocol IBConnectionOwner: IBElement {
    var connections: [AnyConnection]? { get }
}

extension IBConnectionOwner {

    /// Provide recursively all connections.
    public var allConnections: [AnyConnection] {
        var result: [AnyConnection] = []
        _ = browse(skipSelf: false) { element in
            if let casted = element as? IBConnectionOwner, let connections = casted.connections {
                result.append(contentsOf: connections)
            }
            return true
        }
        return result
    }

    /// Provide recursively all connections of children.
    public var childrenConnections: [AnyConnection] {
        var result: [AnyConnection] = []
        _ = browse(skipSelf: true) { element in
            if let casted = element as? IBConnectionOwner {
                if let connections = casted.connections {
                    result.append(contentsOf: connections)
                }
            }
            return true
        }
        return result
    }

    public func connectionsWith(destination identifiable: IBIdentifiable, recursive: Bool = true) -> [AnyConnection] {
        return connectionsWith(destination: identifiable.id, recursive: recursive)
    }

    public func connectionsWith(destination id: String, recursive: Bool = true) -> [AnyConnection] {
        if recursive {
            // OPTI: we browse all hierachy here but normally we could find only on view hierarchy ie. for a view a parent view or view controller
            // but we do not keep parent view  or controller now in view so we cannot return to parent. (see commented IBElement#parent)
            var result: [AnyConnection] = []
            _ = browse(skipSelf: false) { element in
                if let casted = element as? IBConnectionOwner, let connections = casted.connections {
                    for connection in connections where connection.connection.destination == id {
                        result.append(connection)
                    }
                }
                return true
            }
            return result
        } else {
            return (self.connections ?? []).filter { $0.connection.destination == id }
        }
    }

    public func childrenConnectionsWith(destination identifiable: IBIdentifiable) -> [AnyConnection] {
        return childrenConnectionsWith(destination: identifiable.id)
    }

    public func childrenConnectionsWith(destination id: String) -> [AnyConnection] {
        // OPTI: we browse all hierachy here but normally we could find only on view hierarchy ie. for a view a parent view or view controller
        // but we do not keep parent view  or controller now in view so we cannot return to parent. (see commented IBElement#parent)
        var result: [AnyConnection] = []
        _ = browse(skipSelf: true) { element in
            if let casted = element as? IBConnectionOwner, let connections = casted.connections {
                for connection in connections where connection.connection.destination == id {
                    result.append(connection)
                }
            }
            return true
        }
        return result
    }
}

// MARK: IBElement

/// Represent a node into hierarchical tree.
public protocol IBElement {
    /// Get a list of children of this element.
    var children: [IBElement] { get }
    // var parent: IBElement? { get }
}

extension IBElement {

    /* /// Return element hierarchy ie. all parents.
     public var hierarchy: [IBElement] {
     if let parent = parent {
     return [parent] + parent.hierarchy
     }
     return []
     }*/

    /// Return all tree nodes elements under this tree node (recursively).
    public var flattened: [IBElement] {
        return [self] + children.flatMap { $0.flattened }
    }

    /// Return `true` if there is no children element.
    public var isLeaf: Bool {
        return children.count == 0
    }

    /// Browse the element tree and call for each element the `visitor` callback.
    /// If the callback return false, stop browsing.
    public func browse(skipSelf: Bool = false, _ visitor: (IBElement) -> Bool) -> Bool {
        if skipSelf || visitor(self) {
            let children = self.children
            for child in children {
                if !child.browse(skipSelf: false, visitor) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }

    /// Return all the children of specified type, recursively.
    public func children<T: IBElement>(of type: T.Type, recursive: Bool = true) -> [T] {
        var result: [T] = []
        if recursive {
            _ = browse(skipSelf: true) { element in
                if let casted = element as? T {
                    result.append(casted)
                }
                return true
            }
        } else {
            let children = self.children
            for child in children {
                if let casted = child as? T {
                    result.append(casted)
                }
            }
        }
        return result
    }

    /// Return direct children element with specific key.
    public func with<T: IBKeyable>(key: String) -> T? {
        let children = self.children
        for child in children {
            if let keyable = child as? IBKeyable {
                if keyable.key == key {
                    return keyable as? T
                }
            }
        }
        return nil
    }

    /// Return direct children element with specific id.
    public func with<T: IBIdentifiable>(id: String) -> T? {
        let children = self.children
        for child in children {
            if let identifiable = child as? IBIdentifiable {
                if identifiable.id == id {
                    return identifiable as? T
                }
            }
        }
        return nil
    }

}

extension IBElement {
    // default implementation using `Mirror`.
    public var children: [IBElement] {
        return Mirror.children(of: self)
    }
}

// MARK: IBAny
/// Common protocol for intermediate element which help to decode.
public protocol IBAny: IBElement {
    associatedtype NestedElement/*: IBElement*/
    var nested: NestedElement { get }
}

extension IBAny {
    // default implementation using `Mirror``.
    public var children: [IBElement] {
        if let element = nested as? IBElement { // remove this code if NestedElement extends IBElement
            return [element]
        }
        return []
    }
}

// MARK: reflection extension
extension Mirror {

    static func children<T>(of element: T) -> [T] {
        let mirror = Mirror(reflecting: element)
        let direct: [T] = mirror.children(T.self)
        let fromArray: [T] = mirror.children([T].self).flatMap { $0 }
        return direct + fromArray
    }

    private func children <T> (_ type: T.Type) -> [T] {
        // Workaround: Swift 5.3 can't cast `Any` to `Optional<T>` directly due to:
        // > error: cannot downcast from 'Any' to a more optional type 'Optional<T>'
        func cast<From, To>(_ value: From, _: To.Type) -> To? {
            return value as? To
        }
        return self.children.compactMap { (_, value) in
            // Note: value as? T fails even the value is .some on Swift 5.3
            // This issue SR-1999 has been fixed since Swift 5.4
            if let some = cast(value, Optional<T>.self) {
                return some
            }
            return value as? T
        }
    }
}
