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
        let url = "Tests/Resources/View.xib"

        do {
            let file = try XibFile(path: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyLaunchScreen() {
        let url = "Tests/Resources/Launch Screen.storyboard"

        do {
            let file = try StoryboardFile(path: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testEmptyStoryboard() {
        let url = "Tests/Resources/StoryboardEmpty.storyboard"
        do {
            let file = try StoryboardFile(path: url)
            print(file.document.targetRuntime)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithAsset() {
        let url = "Tests/Resources/StoryboardAsset.storyboard"
        do {
            let file = try StoryboardFile(path: url)
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
        let url = "Tests/Resources/StoryboardAllViews.storyboard"

        do {
            let file = try StoryboardFile(path: url)
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
