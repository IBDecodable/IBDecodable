//
//  GithubTests.swift
//  IBDecodableTests
//
//  Created by phimage on 11/05/2018.
//

import XCTest
@testable import IBDecodable
import Foundation
import SWXMLHash

class GithubTests: XCTestCase {
    
    let type: IBType = .storyboard
    override func setUp() {}
    
    var dstURL: URL {
        let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dst = doc.appendingPathComponent(type.rawValue)
        try? FileManager.default.createDirectory(at: dst, withIntermediateDirectories: true, attributes: nil)
        return dst
    }

    func testDownload() {
        let expect = self.expectation(description: "filedl")
        
        guard let token = ProcessInfo.processInfo.environment["GITHUB_ACCESS_TOKEN"] else {
            XCTFail("You must define env var GITHUB_ACCESS_TOKEN")
            return
        }
        let dl = IBDownloader(accessToken: token)
        
        let perPage = 100
        let nbPage = 1000
        let total = perPage * nbPage
        var cpt = 0
        
        let semaphore = DispatchSemaphore(value: 0)
        for page in 0...nbPage {
            var cptPage = 0
            dl.downloadPage(ext: type, page: page, perPage: perPage) { localURL, response in
                cpt += 1
                cptPage += 1
                // if let string = try? String(contentsOf: localURL) {
                // print(string)
                //}
                do {
                    let filename = localURL.lastPathComponent
                        .replacingOccurrences(of: "CFNetworkDownload_", with: "")
                        .replacingOccurrences(of: ".tmp", with: "")
                        + (response.suggestedFilename?.replacingOccurrences(of: ".txt", with: ""))!
                    let fileDst = self.dstURL.appendingPathComponent(filename)
                    try FileManager.default.moveItem(at: localURL, to: fileDst)
                } catch {
                    print("\(error)")
                }
                
                if cptPage == perPage { // page end
                    semaphore.signal()
                }
                if cpt == total {
                    expect.fulfill()
                }
            }
            semaphore.wait() // do not make new page request before downloading all previous page files
            Thread.sleep(forTimeInterval: 60)
        }
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                print("\(error)")
            }
        }
    }
    
    func testLocal() {
        if let urls = try? FileManager.default.contentsOfDirectory(at: dstURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            for url in urls {
                if url.pathExtension == type.rawValue {
                    do { 
                        switch type {
                    case .storyboard:
                        let file = try StoryboardFile(url: url)
                        _ = file.document
                    case .xib:
                        let file = try XibFile(url: url)
                        _ = file.document
                        }
                    } catch {
                        switch error {
                        case XMLDeserializationError.implementationIsMissing(let text):
                            if text == "watchKit" {
                               try? FileManager.default.removeItem(at: url)
                            }
                        default:
                            break
                        }
                        print("\(error)")
                    }
                }
            }
            let v = AttributeMissing.instance.values
            for (name, keys) in v {
                print("\(name): \(keys)")
            }
            print("\(urls.count)")
        }
    }
}
