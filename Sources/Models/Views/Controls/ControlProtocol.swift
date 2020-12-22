//
//  ControlProtocol.swift
//  
//
//  Created by Ibrahim Hassan on 22/12/20.
//

import Foundation

/// Protocol to decode UIControl https://developer.apple.com/documentation/uikit/uicontrol
public protocol ControlProtocol: ViewProtocol {
    var isEnabled: Bool? { get }
    var isHighlighted: Bool? { get }
    var isSelected: Bool? { get }
    var contentHorizontalAlignment: String? { get }
    var contentVerticalAlignment: String? { get }
}
