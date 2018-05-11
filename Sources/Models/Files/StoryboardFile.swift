//
//  StoryboardFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

import SWXMLHash
import Foundation

public class StoryboardFile: InterfaceBuilderFile {

    public var pathString: String

    public let ibType: IBType = .storyboard
    public let document: StoryboardDocument

    public init(path: String) throws {
        self.pathString = path
        self.document = try type(of: self).parseContent(pathString: path)
    }

    public init(url: URL) throws {
        self.pathString = url.absoluteString
        self.document = try type(of: self).parseContent(url: url)
    }

    private static func parseContent(pathString: String) throws -> StoryboardDocument {
        let parser = InterfaceBuilderParser()
        let content = try String(contentsOfFile: pathString)
        return try parser.parseStoryboard(xml: content)
    }

    private static func parseContent(url: URL) throws -> StoryboardDocument {
        let parser = InterfaceBuilderParser()
        let content = try String(contentsOf: url)
        return try parser.parseStoryboard(xml: content)
    }

}
