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
            let images: [Image] = resources.compactMap { $0.resource as? Image }
            XCTAssertFalse(images.isEmpty, "There is no image")
            // Check named colors
            let namedColor: [NamedColor] =  resources.compactMap { $0.resource as? NamedColor }
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
            guard let scene = file.document.scenes?.first else {
                XCTFail("No scene")
                return
            }
            guard let views = scene.viewController?.viewController.rootView?.subviews, !views.isEmpty else {
                XCTFail("No subviews")
                return
            }
            let clazz = views.map { $0.view.elementClass }
            print("\(clazz.count)")

            XCTAssertFalse(scene.customObjects?.isEmpty ?? true)
            XCTAssertFalse(scene.customViews?.isEmpty ?? true)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithUserDefinedAttributes() {
        let url = self.url(forResource:"StoryboardUserDefinedAttributes", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            if let scenes = file.document.scenes {
                for scene in scenes {
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
            XCTAssertEqual(anyViewControllers.count, anyViewControllers.compactMap({ $0 }).count, "Some VC are not decodable")
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardConnections() {
        let url = self.url(forResource:"StoryboardConnections", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)

            let viewControllers = file.document.scenes?.map { $0.viewController?.viewController } ?? []
            let rootConnections = viewControllers.compactMap { $0?.connections }.flatMap { $0 }.compactMap { $0.connection }
            XCTAssertFalse(rootConnections.isEmpty)

            let connections: [AnyConnection] = file.document.children(of: AnyConnection.self)
            XCTAssertEqual(connections.count, 9)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAttributes() {
        let url = self.url(forResource:"StoryboardAttributes", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            
            let _ = file.document.scenes?.map { $0.viewController?.viewController } ?? []
            // print("\(viewControllers)")
            // TODO browser to get attributes
            
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
                    XCTFail("\(error) \(url)")
                }
            }
        }
    }

    func testStoryboardElementChildren() {
        if let urls = urls(withExtension: "storyboard") {
            for url in urls {
                do {
                    let file = try StoryboardFile(url: url)
                    let name = url.lastPathComponent
                    print(name)

                    let document = file.document
                    printTree(element: document)
        
                    let children = document.children
                    let flattened = document.flattened
                    
                    if name.contains("Empty")  {
                        XCTAssertTrue(children.isEmpty, "must have no children element for doc \(name)")
                        XCTAssertTrue(flattened.count == 1, "must have no flattened children element for doc \(name)")
                    } else {
                        XCTAssertTrue(children.count > 0, "no children element for doc \(name)")
                        XCTAssertTrue(flattened.count > 2, "no flattened children element for doc \(name)")
                        
                        // Example code for indexation
                        var duplicate: [IBIdentifiable] = []
                        let mapById: [String: IBIdentifiable] = flattened.reduce([:]) { result, element in
                            var result = result
                            if let identifiable = element as? IBIdentifiable {
                                if let oldValue = result[identifiable.id]/*, (identifiable as AnyObject !== oldValue as AnyObject)*/ {
                                    duplicate.append(oldValue)
                                    print("duplicate \(identifiable.id): \(identifiable) with \(oldValue)")
                                } else {
                                    result[identifiable.id] = identifiable
                                }
                            }
                            return result
                        }
                        XCTAssertTrue(mapById.count > 2, "no element by id \(name)")
                        XCTAssertTrue(duplicate.isEmpty, "there is duplicate element by id \(name)")
                        
                        // Example code for browsing
                        _ = document.browse { element in
                           
                            return true // go on
                        }
                        
                    }
                } catch {
                    XCTFail("\(error)  \(url)")
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
        if let urls = bundle.urls(forResourcesWithExtension: ext, subdirectory: nil), !urls.isEmpty {
            return urls
        }
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: "Tests/Resources") {
            return paths.filter { $0.hasSuffix(".\(ext)") }.map { URL(fileURLWithPath: "Tests/Resources/\($0)") }
        }
        return nil
    }

    func printTree(element: IBElement, level: Int = 0) {
        var elementString = "\(type(of: element))"
        if let identifiable = element as? IBIdentifiable {
            elementString += "[id=\(identifiable.id)]"
        }
        if let keyable = element as? IBKeyable, let key = keyable.key {
            elementString += "[key=\(key)]"
        }
        print(String(repeating: "-", count: level) + elementString)
        
        element.children.forEach { child in
            printTree(element: child, level: level + 4)
        }
    }
}
