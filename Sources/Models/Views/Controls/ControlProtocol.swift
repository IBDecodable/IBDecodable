//
//  ControlProtocol.swift
//  
//
//  Created by phimage on 19/09/2020.
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
