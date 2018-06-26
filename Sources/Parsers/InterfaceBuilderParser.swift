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
        return try decodeValue(document)
    }

    public enum Error: Swift.Error {
        case invalidFormatFile
        case legacyFormat
        case parsingError(Swift.Error)
    }

}
