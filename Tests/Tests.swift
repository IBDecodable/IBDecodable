//
//  Tests.swift
//  Tests
//
//  Created by phimage on 31/03/2018.
//

import XCTest
@testable import IBDecodable

class Tests: XCTestCase {

    func testEmptyView() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "View", withExtension: "xml") else {
            XCTFail("File not found")
            return
        }
        do {
            let file = try XibFile(url: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyLaunchScreen() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Launch Screen", withExtension: "xml") else {
            XCTFail("File not found")
            return
        }
        do {
            let file = try StoryboardFile(url: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyStoryboard() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "Storyboard", withExtension: "xml") else {
            XCTFail("File not found")
            return
        }
        do {
            let file = try StoryboardFile(url: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithAsset() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "StoryboardAsset", withExtension: "xml") else {
            XCTFail("File not found")
            return
        }
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
        guard let url = Bundle(for: type(of: self)).url(forResource: "StoryboardAllViews", withExtension: "xml") else {
            XCTFail("File not found")
            return
        }
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

}
