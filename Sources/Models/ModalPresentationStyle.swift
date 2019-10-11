//
//  ModalPresentationStyle.swift
//  IBDecodable
//
//  Created by eidd5180 on 11/10/2019.
//

import SWXMLHash

public enum ModalPresentationStyle: XMLAttributeDecodable, KeyDecodable, Equatable {
       case automatic, fullScreen, pageSheet, formSheet, currentContext
       case custom, overFullScreen, overCurrentContext, blurOverFullScreen, popover, none

       public func encode(to encoder: Encoder) throws { fatalError() }

       static func decode(_ attribute: XMLAttribute) throws -> ModalPresentationStyle {
           switch attribute.text {
           case "automatic": return .automatic
           case "fullScreen": return .fullScreen
           case "pageSheet": return .pageSheet
           case "formSheet": return .formSheet
           case "currentContext": return .currentContext
           case "custom": return .custom
           case "overFullScreen": return .overFullScreen
           case "overCurrentContext": return .overCurrentContext
           case "blurOverFullScreen": return .blurOverFullScreen
           case "popover": return .popover
           case "none": return .none
           default:
               return .none
           }
       }
   }
