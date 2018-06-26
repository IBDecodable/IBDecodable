//
//  InterfaceBuilder.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/05.
//

import SWXMLHash
import Foundation

private let cocoaTouchKey = "com.apple.InterfaceBuilder3.CocoaTouch.XIB"

public struct InterfaceBuilderParser {

    private let xmlParser: SWXMLHash

    public init(detectParsingErrors: Bool = true) {
        xmlParser = SWXMLHash.config { options in
            options.detectParsingErrors = detectParsingErrors
        }
    }

    public func parseXib(xml: String) throws -> XibDocument {
        return try parseDocument(xml: xml)
    }

    public func parseStoryboard(xml: String) throws -> StoryboardDocument {
        return try parseDocument(xml: xml)
    }

    internal func parseDocument<D: InterfaceBuilderDocument & IBDecodable>(xml: String) throws -> D {
        return try parseDocument(xmlIndexer: xmlParser.parse(xml))
    }

    internal func parseDocument<D: InterfaceBuilderDocument & IBDecodable>(data: Data) throws -> D {
        return try parseDocument(xmlIndexer: xmlParser.parse(data))
    }

    internal func parseDocument<D: InterfaceBuilderDocument & IBDecodable>(xmlIndexer: XMLIndexer) throws -> D {
        if case .parsingError(let error) = xmlIndexer {
            throw Error.parsingError(error)
        }
        guard let document: XMLIndexer = xmlIndexer.byKey("document") else {
            guard let archive: XMLIndexer = xmlIndexer.byKey("archive"),
                let type: String = try? archive.attributeValue(of: "type") else {
                    throw Error.invalidFormatFile
            }

            switch type {
            case cocoaTouchKey:
                throw Error.legacyFormat
            default:
                throw Error.invalidFormatFile
            }
        }
        let doc: D = try decodeValue(document)
        if doc.targetRuntime.os == .iOS {
            printattr(document)
        }

        return doc
    }

    func printattr(_ index: XMLIndexer) {
        if let element = index.element {
            if element.name != "simulatedMetricsContainer"
                &&  element.name != "dependencies" {
                if  element.name != "document"
                    &&  element.name != "color" {
                    let attr = element.allAttributes
                    if !attr.isEmpty && (index.parsed ?? false) {

                        AttributeMissing.instance.add(element.name, Array(attr.keys))
                    }
                }

                for child in index.children {
                    printattr(child)
                }
            }
        }
    }

    public enum Error: Swift.Error {
        case invalidFormatFile
        case legacyFormat
        case parsingError(Swift.Error)
    }

}

public class AttributeMissing {
    public static let instance: AttributeMissing = AttributeMissing()

    public var values: [String: [String]] = [:]

    func add(_ name: String, _ keys: [String]) {
        if values[name] == nil {
            values[name] = []
        }

        values[name]?.append(contentsOf: keys)

        values[name] = Array(Set(values[name]!))

       // print("\(name): \(keys)")
    }
}
