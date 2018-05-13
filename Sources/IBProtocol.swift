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

// MARK: IBElement

/// Represent a node into hierarchical tree.
public protocol IBElement {
    /// Get a list of children of this element.
    var children: [IBElement] { get }
    // var parent: IBElement? { get }
}

extension IBElement {

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
        let optional: [T]  = mirror.children(Optional<T>.self).compactMap { $0 }
        return direct + fromArray + optional
    }

    private func children <T> (_ type: T.Type) -> [T] {
        //swiftlint:disable:next force_cast
        return self.children.map { $0.value }.filter { $0 is T } as! [T]
    }
}
