//
//  Tests.swift
//  Tests
//
//  Created by phimage on 31/03/2018.
//

import XCTest
@testable import IBDecodable
import Foundation

class Tests: XCTestCase {

    override func setUp() {}

    func testEmptyView() {
        let url = self.url(forResource:"View", withExtension: "xib")
        do {
            let file = try XibFile(url: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyLaunchScreen() {
        let url = self.url(forResource:"Launch Screen", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            let document = file.document
            print(document.targetRuntime)
            XCTAssertTrue(document.launchScreen)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyStoryboard() {
        let url = self.url(forResource:"StoryboardEmpty", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            let document = file.document
            XCTAssertFalse(document.launchScreen)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithAsset() {
        let url = self.url(forResource:"StoryboardAsset", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            guard let resources = file.document.resources, !resources.isEmpty else {
                XCTFail("No asset resources found")
                return
            }
            // Check images
            let images: [Image] = resources.flatMap { $0.resource as? Image }
            XCTAssertFalse(images.isEmpty, "There is no image")
            // Check named colors
            let namedColor: [NamedColor] =  resources.flatMap { $0.resource as? NamedColor }
            XCTAssertFalse(namedColor.isEmpty, "There is no named color")
            namedColor.forEach {
                XCTAssertNotNil($0.color)
            }

        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAllViews() {
        let url = self.url(forResource:"StoryboardAllViews", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            guard let views = file.document.scenes?.first?.viewController?.viewController.rootView?.subviews, !views.isEmpty else {
                XCTFail("No subviews")
                return
            }
            let clazz = views.map { $0.view.elementClass }
            print("\(clazz.count)")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithUserDefinedAttributes() {
        let url = self.url(forResource:"StoryboardUserDefinedAttributes", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            
            for scene in file.document.scenes ?? [] {
                if let controller = scene.viewController?.viewController, let attributes = controller.userDefinedRuntimeAttributes {
                    
                    XCTAssertFalse(attributes.isEmpty, "No user defined attributes on root controller")
                    if let rootView = controller.rootView {
                        if let viewAttributes = rootView.userDefinedRuntimeAttributes {
                            XCTAssertFalse(viewAttributes.isEmpty, "No user defined attributes on root view")
                        } else {
                            XCTFail("No user defined attributes on root view")
                        }
                    } else {
                        XCTFail("No root view for controller \(controller)")
                    }
                } else {
                    XCTFail("No user defined attributes on root controller")
                }
            }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAllControllers() {
        let url = self.url(forResource:"StoryboardControllers", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
         
            let anyViewControllers = file.document.scenes?.map { $0.viewController } ?? []
            XCTAssertEqual(anyViewControllers.count, anyViewControllers.flatMap({ $0 }).count, "Some VC are not decodable")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardConnections() {
        let url = self.url(forResource:"StoryboardConnections", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            
            let viewControllers = file.document.scenes?.map { $0.viewController?.viewController } ?? []
            let rootConnections = viewControllers.flatMap { $0?.connections }.flatMap { $0 }.flatMap { $0.connection }
            XCTAssertFalse(rootConnections.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAttributes() {
        let url = self.url(forResource:"StoryboardAttributes", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            
            let viewControllers = file.document.scenes?.map { $0.viewController?.viewController } ?? []
            print("\(viewControllers)")
            
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAlls() {
        if let urls = urls(withExtension: "storyboard") {
            for url in urls {
                do {
                    let file = try StoryboardFile(url: url)
                    
                    for scene in file.document.scenes ?? [] {
                        if let viewController = scene.viewController?.viewController {
                            #if os(iOS)
                                // Check that element class could be loaded (need to import framework first)
                            let cls: AnyClass? = NSClassFromString(viewController.elementClass)
                            XCTAssertNotNil(cls, viewController.elementClass)
                            #endif
                        }
                    }
                } catch {
                    XCTFail("\(error)")
                }
            }
        }
    }

    // MARK: Utils

    lazy var bundle: Bundle = {
        return Bundle(for: type(of: self))
    }()

    func url(forResource resource: String, withExtension ext: String) -> URL {
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        return URL(fileURLWithPath: "Tests/Resources/\(resource).\(ext)")
    }

    func urls(withExtension ext: String) -> [URL]? {
        if let urls = bundle.urls(forResourcesWithExtension: ext, subdirectory: nil) {
            return urls
        }
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: "Tests/Resources") {
            return paths.filter { $0.hasSuffix(".\(ext)") }.map { URL(fileURLWithPath: $0) }
        }
        return nil
    }

}
