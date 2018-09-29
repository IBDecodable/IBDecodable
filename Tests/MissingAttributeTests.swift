//
//  MissingAttributeTests.swift
//  IBDecodableTests
//
//  Created by Yuta Saito on 2018/09/29.
//

import XCTest
@testable import IBDecodable

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
                _ = try XibFile(url: remoteURL)
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
            case .failed(let error):
                XCTFail("\(error)")
            }
        }
        waitForExpectations(timeout: 100) { (error) in
            _ = error.map { XCTFail("\($0)") }
        }
    }

    func fetchSample(handler: @escaping (Result<Github.Response>) -> Void) {
        guard let token = ProcessInfo.processInfo.environment["GITHUB_ACCESS_TOKEN"] else {
            XCTFail("You must define env var GITHUB_ACCESS_TOKEN")
            return
        }
        let github = Github(accessToken: token)
        github.downloadPage(extension: "xib", perPage: 10, handler: { (result) in
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
}
