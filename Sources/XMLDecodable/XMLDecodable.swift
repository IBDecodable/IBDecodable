//
//  XMLDecodable.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/22.
//

import SWXMLHash
import Foundation

protocol XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self
}

protocol XMLDecodable {

    static func decode(_ xml: XMLIndexer) throws -> Self
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) throws -> T {
    let value = try T.decode(xml)

    var xml = xml

    var parsed = true
    for var e in xml.children {
        if e.parsed == nil {
            e.parsed = false
            let name = e.element?.name ?? ""

            if name == "color"
                || name == "adaptation" // due to parsing from device directly
                || (name == "rect" && xml.element!.name == "variation")
                || (name == "variation" && xml.element!.name == "constraint")
                || (name == "textAttributes" && xml.element!.name == "navigationBar")
                || name == "offsetWrapper"
                || name == "subviews"
                || name == "objects"
                || name == "dependencies"
                || name == "scenes"
                || name == "prototypes"
                || name == "connections"
                || name == "animations"
                || name == "fontDescription"
                || (name == "barButtonItem" && xml.element!.name == "navigationItem")
                || (name == "nil" && xml.element!.name == "navigationItem")
                || (name == "string" && xml.element!.name == "navigationItem")
                || (name == "textField" && xml.element!.name == "navigationItem")
                || (name == "buton" && xml.element!.name == "navigationItem")
                || (name == "view" && xml.element!.name == "navigationItem")
                || (name == "attributedString" && xml.element!.name == "state")
                || (name == "attributedString" && xml.element!.name == "variation")
                || (name == "contentFilters" && xml.element!.name == "view")
                || (xml.element!.name == "collectionView")
                || name == "constraints"
                || (xml.element!.name == "tableView")
                || name == "classes" // TODO study
                || name == "simulatedMetricsContainer"
                || name == "simulatedOrientationMetrics"
                || name == "simulatedStatusBarMetrics"
                || name == "simulatedScreenMetrics"
                || name == "freeformSimulatedSizeMetrics"
                || name == "sections"
                || name == "resources"
                || name == "attributes"
                || name == "customFonts"
                || name == "gestureRecognizers"
                || name == "segmentedControl"
                || name == "userDefinedRuntimeAttributes"
                || name == "collectionReusableView"
                || name == "rightBarButtonItems"
                || name == "leftBarButtonItems"
                || name == "fragment"
                || name == "userGuides"
                || name == "inset"
                || name == "userGuides"
                || name == "accessibility"
                || name == "contentFilters"
                || name == "edgeInsets"
                || name == "cells"
                || name == "inferredMetricsTieBreakers"// TODO study
            {
                 e.parsed = true
            } else {
                print("\(name): \(String(describing: xml.element?.name))")
            }
        }
        if !e.parsed! {
            parsed = false
            break
        }
    }
    xml.parsed = parsed
    return value
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) -> T? {
    let value = try? T.decode(xml)
    return value
}

protocol KeyDecodable: Encodable {
}
