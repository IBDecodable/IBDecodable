//
//  MissingAttributeTests.swift
//  IBDecodableTests
//
//  Created by Yuta Saito on 2018/09/29.
//

import XCTest
@testable import IBDecodable

#if DISABLE_REMOTE_RESOURCES_TEST
#else
class MissingAttributeTests: XCTestCase {

    lazy var cacheDirPath: URL = {
        return self.fileManager
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("ibdecodable")
    }()

    let fileManager: FileManager = .default

    func testRemoteResouces() {

        func testFile(remoteURL: URL) {
            do {
                let content = try Data(contentsOf: remoteURL)
                let parser = InterfaceBuilderParser()
                let (_, indexer) = try parser.parseDocumentTraverse(data: content, type: XibDocument.self)
                let result = indexer.dump()
                print(result.description)
                print("success: \(remoteURL)")
            }
            catch let error as InterfaceBuilderParser.Error {
                switch error {
                case .legacyFormat: return
                case .macFormat: return
                default:
                    XCTFail("error: \(remoteURL): \(error)")
                }
            }
            catch {
                XCTFail("error: \(remoteURL): \(error)")
            }
        }

        let expect = expectation(description: "Download")
        fetchSample { (result) in
            defer { expect.fulfill() }
            switch result {
            case .success(let response):
                response.items.forEach { testFile(remoteURL: $0.rawURL) }
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
        waitForExpectations(timeout: 300) { (error) in
            _ = error.map { XCTFail("\($0)") }
        }
    }

    func fetchSample(handler: @escaping (Result<Github.Response, Swift.Error>) -> Void) {
        guard let token = ProcessInfo.processInfo.environment["GITHUB_ACCESS_TOKEN"] else {
            handler(.failure(Error.missingAccessToken))
            return
        }
        let github = Github(accessToken: token)
        github.downloadPage(extension: "xib", perPage: 100, handler: { (result) in
            handler(result)
        })
    }

    func readCache(urls: [URL]) {
        if fileManager.fileExists(atPath: cacheDirPath.absoluteString) {
            try! fileManager.createDirectory(
                at: cacheDirPath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        try! fileManager.contentsOfDirectory(
            at: cacheDirPath,
            includingPropertiesForKeys: nil,
            options: []
        )
    }

    enum Error: Swift.Error {
        case missingAccessToken
    }
}

extension InterfaceBuilderParser {
    internal func parseDocumentTraverse<D: InterfaceBuilderDocument & IBDecodable>(data: Data, type: D.Type) throws -> (D, TraverseXMLIndexer) {
        let indexer = TraverseXMLIndexer(indexer: xmlParser.parse(data))
        return (try parseDocument(xmlIndexer: indexer), indexer)
    }
}

import enum SWXMLHash.XMLIndexer
import class SWXMLHash.XMLElement
import enum SWXMLHash.IndexingError

struct TraverseResult: CustomStringConvertible {
    let name: String
    let attributes: [String: String]
    let children: [TraverseResult]

    var description: String { return dump() }

    func dump(depth: Int = 0) -> String {
        let indent = Array(repeating: "-", count: depth).joined()
        return "\(indent)\(name): \(attributes)\n\(children.map { $0.dump(depth: depth + 2) }.joined())"
    }
}

class TraverseXMLIndexer: XMLIndexerType {
    var elementName: String? { return indexer.elementName }
    var elementText: String? { return indexer.elementText }


    let childrenElements: [XMLIndexerType]
    let allElements: [XMLIndexerType]

    let indexer: XMLIndexer
    var attributes: [String: String]
    var allElementNames: [String]

    let all: [TraverseXMLIndexer]
    let children: [TraverseXMLIndexer]

    init(indexer: XMLIndexer) {
        self.indexer = indexer
        self.attributes = indexer.element?.allAttributes.mapValues { $0.text } ?? [:]
        self.allElementNames = indexer.allElements.compactMap { $0.elementName }
        self.all = indexer.all
            .filter { !($0.element === indexer.element) }
            .map(TraverseXMLIndexer.init(indexer: ))
        self.children = indexer.children.map(TraverseXMLIndexer.init(indexer: ))
        allElements = indexer.allElements
        childrenElements = indexer.childrenElements
    }

    func container<K>(keys: K.Type) -> XMLIndexerContainer<K> where K : CodingKey {
        return TraverseXMLIndexerContainer<K>(traverseIndexer: self)
    }

    func byKey(_ key: String) throws -> XMLIndexerType {
        if let index = allElementNames.firstIndex(of: key) {
            allElementNames.remove(at: index)
        }
        guard let element = children.first(where: { $0.elementName! == key }) else {
            throw IndexingError.key(key: key)
        }
        return element
    }

    func byKeyIfPresent(_ key: String) -> XMLIndexerType? {
        if let index = allElementNames.firstIndex(of: key) {
            allElementNames.remove(at: index)
        }
        return children.first { $0.elementName! == key }
    }

    func attributeValue<T>(of attr: String) throws -> T where T : XMLAttributeDecodable {
        if let index = attributes.index(forKey: attr) {
            attributes.remove(at: index)
        }
        return try indexer.attributeValue(of: attr)
    }

    func attributeValue<T>(of attr: String) -> T? where T : XMLAttributeDecodable {
        if let index = attributes.index(forKey: attr) {
            attributes.remove(at: index)
        }
        return try? indexer.attributeValue(of: attr)
    }

    func withAttribute(_ attr: String, _ value: String) throws -> XMLIndexerType {
        if let index = attributes.index(forKey: attr) {
            attributes.remove(at: index)
        }
        let element: XMLElement = try indexer.withAttribute(attr, value).element!
        return children.first(where: { $0.indexer.element! === element })!
    }

    func withAttributeIfPresent(_ attr: String, _ value: String) -> XMLIndexerType? {
        if let index = attributes.index(forKey: attr) {
            attributes.remove(at: index)
        }
        let element: XMLElement? = (try? indexer.withAttribute(attr, value)).flatMap { $0.element }
        return element.flatMap { elm in children.first(where: { $0.indexer.element! === elm }) }
    }


    func dump() -> TraverseResult {
        return TraverseResult(
            name: elementName!,
            attributes: attributes,
            children: children.map { $0.dump() }
        )
    }
}

class TraverseXMLIndexerContainer<K: CodingKey>: XMLIndexerContainer<K> {

    let traverseIndexer: TraverseXMLIndexer

    init(traverseIndexer: TraverseXMLIndexer) {
        self.traverseIndexer = traverseIndexer
        super.init(indexer: traverseIndexer)
    }

    override func elements<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return try (nestedIndexer as! TraverseXMLIndexer).all.map(decodeValue)
    }

    override func children<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return try (nestedIndexer as! TraverseXMLIndexer).children.map(decodeValue)
    }

    override func childrenIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        guard let nestedIndexer: XMLIndexerType = indexer.byKeyIfPresent(key.stringValue) else {
            return nil
        }
        return (nestedIndexer as! TraverseXMLIndexer).children.compactMap(decodeValue)
    }

    override func withAttributeElements<T>(_ attr: K, _ value: String) -> [T]? where T : XMLDecodable {
        let elements: [TraverseXMLIndexer]? = indexer.withAttributeIfPresent(attr.stringValue, value)
            .map { $0 as! TraverseXMLIndexer }?.all
        return elements?.compactMap(decodeValue)
    }

    override func nestedContainer<A>(of key: K, keys: A.Type) throws -> XMLIndexerContainer<A> {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        return TraverseXMLIndexerContainer<A>(traverseIndexer: nestedIndexer as! TraverseXMLIndexer)
    }

    override func nestedContainerIfPresent<A>(of key: K, keys: A.Type) -> XMLIndexerContainer<A>? {
        return try? nestedContainer(of: key, keys: keys)
    }

    override func nestedContainers<A>(of key: K, keys: A.Type) throws -> [XMLIndexerContainer<A>] {
        let nestedIndexer: XMLIndexerType = try indexer.byKey(key.stringValue)
        let elements = (nestedIndexer as! TraverseXMLIndexer).all
        return elements.map(TraverseXMLIndexerContainer<A>.init)
    }
}
#endif
