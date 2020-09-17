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

    func testLaunchScreen() {
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
            
            // check view
            let buttons = file.document.children(of: Button.self)
            let imageViews = file.document.children(of: ImageView.self)
            
            XCTAssertFalse(buttons.isEmpty, "There is no buttons")
            XCTAssertFalse(imageViews.isEmpty, "There is no imageViews")
            
            let states = buttons.compactMap { $0.state }
            XCTAssertFalse(states.isEmpty, "There is no button states")
            
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
            let allViewDistinctCount = 30
            XCTAssertEqual(Set(clazz).count, allViewDistinctCount, "not correct unique element class found in all view storyboard. maybe a new one has been implemented? or there is decodng failure")
            XCTAssertEqual(clazz.count, allViewDistinctCount + 2 /* two switch and two uisearchbar*/, "not correct element found in all view storyboard. added a new one? or there is decodng failure")
            
            XCTAssertFalse(scene.customObjects?.isEmpty ?? true)
            XCTAssertFalse(scene.customViews?.isEmpty ?? true)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardAllViewsCollectionReusableView() {
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
            guard let collectionView = views.map({ $0.view }).first(where: { $0 is CollectionView }) as? CollectionView else {
                XCTFail("No collection view")
                return
            }
            XCTAssertEqual(collectionView.collectionReusableViews?.count, 2)
            XCTAssertEqual(collectionView.collectionReusableViews?.first?.reuseIdentifier, "FirstReuseID")
            XCTAssertEqual(collectionView.sectionHeaderView?.reuseIdentifier, "FirstReuseID")
            XCTAssertEqual(collectionView.collectionReusableViews?.last?.reuseIdentifier, "SecondReuseID")
            XCTAssertEqual(collectionView.sectionFooterView?.reuseIdentifier, "SecondReuseID")
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
            XCTAssertEqual(connections.count, 10)
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

    func testStoryboardReferences() {
        let url = self.url(forResource:"StoryboardReferences", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            
            let references = file.document.scenes?.compactMap { $0.viewControllerPlaceholder } ?? []
            XCTAssertEqual(references.count, 3)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardWithConstraintErrors() {
        let url = self.url(forResource: "StoryboardConstraintErrors", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)
            var ambiguousViews: [IBElement] = []
            _ = file.document.browse { element -> Bool in
                guard let view = element as? ViewProtocol, view.isAmbiguous ?? false else {
                    return true
                }
                ambiguousViews.append(element)
                return true
            }

            XCTAssertEqual(ambiguousViews.count, 2)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testStoryboardHostingController() {
        let url = self.url(forResource:"StoryboardHostingController", withExtension: "storyboard")
        do {
            let file = try StoryboardFile(url: url)

            let hostingControllers = file.document.scenes?.compactMap { $0.viewController?.viewController as? HostingController } ?? []
            XCTAssertEqual(hostingControllers.count, 1)
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
                            // Check that element class could be loaded (need to import framework first, so some could failed)
                            if viewController.framework == "UIKit" {
                                let cls: AnyClass? = NSClassFromString(viewController.elementClass)
                                XCTAssertNotNil(cls, viewController.elementClass)
                            }
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

                    XCTAssertTrue(children.count > 0, "no children element for doc \(name)")
                    XCTAssertTrue(flattened.count > 2, "no flattened children element for doc \(name)")

                    // Example code for indexation
                    let analyser = IBAnalyser(document)
                    if name.contains("Empty")  {
                        XCTAssertTrue(analyser.byId.isEmpty, "must have no element by id \(name)")
                    } else {
                        XCTAssertTrue(analyser.byId.count > 2, "no element by id \(name)")
                    }

                    XCTAssertTrue(analyser.duplicateId.isEmpty, "there is duplicate element by id \(name)")
                } catch {
                    XCTFail("\(error)  \(url)")
                }
            }
        }
        
    }

    func testStoryboardNotParsable() {
        let url = self.url(forResource:"StoryboardNotParsable", withExtension: "xml")
        do {
            _ = try StoryboardFile(url: url)
            
            XCTFail("Must not be parsable")
        } catch {
            if case let InterfaceBuilderParser.Error.parsingError(xmlError) = error {
                #if os(Linux)
                XCTAssertEqual(xmlError.line, 0, "error line seems to be fixed on linux. Please update the test by removing #if os(Linux)")
                #else
                XCTAssertEqual(xmlError.line, 13, "error must has specified line")
                #endif
            } else {
                XCTFail("wrong error type \(error)")
            }
        }
    }

    func testViewControllerWithPlaceholderOutlet() {
        let url = self.url(forResource: "ViewControllerWithOutlets", withExtension: "xib")
        do {
            let file = try XibFile(url: url)
            let placeholders = file.document.placeholders ?? []
            XCTAssertEqual(placeholders.count, 2)

            let fileOwnerPlaceholder = placeholders.first { $0.placeholderIdentifier == "IBFilesOwner" }
            XCTAssertNotNil(fileOwnerPlaceholder)

            let connections = fileOwnerPlaceholder?.connections ?? []
            XCTAssertEqual(connections.count, 1)

            let outlet = connections.first?.connection as? Outlet
            XCTAssertNotNil(outlet)
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }

    func testCollectionViewCellContentView() {
        let url = self.url(forResource: "CollectionViewCell", withExtension: "xib")
        do {
            let file = try XibFile(url: url)
            let rootView = file.document.views?.first?.view
            XCTAssertNotNil(rootView, "There should be a root view")
            XCTAssertEqual(rootView?.elementClass, "UICollectionViewCell")

            guard let cell = rootView as? CollectionViewCell else {
                XCTFail("The root view should be a collection view cell")
                return
            }
            XCTAssertEqual(cell.contentView.key, "contentView")
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }
    
    func testCollectionReusableView() {
        let url = self.url(forResource: "CollectionReusableView", withExtension: "xib")
        do {
            let file = try XibFile(url: url)
            let rootView = file.document.views?.first?.view
            XCTAssertNotNil(rootView, "There should be a root view")
            XCTAssertEqual(rootView?.elementClass, "UICollectionReusableView")
            
            guard let reusableView = rootView as? CollectionReusableView else {
                XCTFail("The root view should be a collection reusable view")
                return
            }
            XCTAssertEqual(reusableView.reuseIdentifier, "ReuseID")
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }

    func testLabelsWithFonts() {
        let url = self.url(forResource: "LabelsWithFonts", withExtension: "xib")
        do {
            let file = try XibFile(url: url)

            let rootView = file.document.views?.first?.view
            XCTAssertNotNil(rootView, "There should be a root view")

            let stackView = rootView?.subviews?.first?.view
            XCTAssertNotNil(stackView, "There should be a stack view")
            XCTAssertEqual(stackView?.elementClass, "UIStackView")

            let labels = (stackView?.subviews ?? []).compactMap { $0.view as? Label }
            XCTAssertEqual(labels.count, 3)

            let fontDescriptions = labels.compactMap { $0.fontDescription }
            XCTAssertEqual(fontDescriptions.count, 3)

            let customFont = fontDescriptions[0]
            guard case .custom = customFont else {
                XCTFail("The label should have a custom type")
                return
            }
            XCTAssertEqual(customFont.pointSize, 17.0)

            let systemFont = fontDescriptions[1]
            guard case .system = systemFont else {
                XCTFail("The label should have a system type")
                return
            }

            let textStyle = fontDescriptions[2]
            guard case .textStyle = textStyle else {
                XCTFail("The label should have a textStyle type")
                return
            }
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }

    func testViewsWithTextColorAndBackgroundColor() {
        let url = self.url(forResource: "ViewsWithTextColorAndBackgroundColor", withExtension: "xib")
        do {
            let file = try XibFile(url: url)

            let stackView = file.document.views?.first?.view.subviews?.first?.view
            XCTAssertNotNil(stackView, "There should be a stack view")
            XCTAssertEqual(stackView?.elementClass, "UIStackView")

            let subviews: [ViewProtocol] = (stackView?.subviews ?? []).map { $0.view }
            XCTAssertEqual(subviews.count, 3)

            guard let labelWithTextAndBackgroundColor = subviews[0] as? Label,
                let labelWithTextColorOnly = subviews[1] as? Label,
                let textViewWithTextAndBackgroundColor = subviews[2] as? TextView else {
                    XCTFail("Stackview should have two labels and one textview")
                    return
            }

            XCTAssertNotNil(labelWithTextAndBackgroundColor.textColor)
            XCTAssertNotNil(labelWithTextColorOnly.textColor)
            XCTAssertNotNil(textViewWithTextAndBackgroundColor.textColor)
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }

    func testViewsWithBackgroundColorAndTintColor() {
        let url = self.url(forResource: "ViewsWithBackgroundColor", withExtension: "xib")
        do {
            let file = try XibFile(url: url)
            let views = (file.document.views ?? []).map { $0.view }
            XCTAssertTrue(views.count > 0)
            views.forEach {
                XCTAssertNotNil($0.backgroundColor)
                XCTAssertNotNil($0.tintColor)
            }
        } catch {
            XCTFail("\(error)  \(url)")
        }
    }

    // MARK: Utils

    lazy var bundle: Bundle = {
        return Bundle(for: type(of: self))
    }()

    let resourcesURL: URL = {
        #if compiler(>=5.3)
        let thisFilePath = #filePath
        #else
        let thisFilePath = #file
        #endif
        return URL(fileURLWithPath: thisFilePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
    }()

    func url(forResource resource: String, withExtension ext: String) -> URL {
        #if !os(Linux)
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        #endif
        var url = URL(fileURLWithPath: "Tests/Resources/\(resource).\(ext)")
        if !FileManager.default.fileExists(atPath: url.path) {
            url = resourcesURL.appendingPathComponent(resource).appendingPathExtension(ext)
        }
        return url
    }

    func urls(withExtension ext: String) -> [URL]? {
        #if !os(Linux)
        if let urls = bundle.urls(forResourcesWithExtension: ext, subdirectory: nil), !urls.isEmpty {
            return urls
        }
        #endif
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: "Tests/Resources") {
            return paths.filter { $0.hasSuffix(".\(ext)") }.map { URL(fileURLWithPath: "Tests/Resources/\($0)") }
        }
        if let urls = try? FileManager.default.contentsOfDirectory(at: resourcesURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            return urls.filter { $0.pathExtension == ext }
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
