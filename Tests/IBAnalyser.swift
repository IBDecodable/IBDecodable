//
//  Analyser.swift
//  IBDecodable
//
//  Created by phimage on 10/05/2018.
//

import IBDecodable

struct IBAnalyser {

    var byId: [String: IBIdentifiable] = [:]
    var duplicateId: [IBIdentifiable] = []

    var byResuseId: [String: IBReusable] = [:]

    var byType: [String: [IBElement]] = [:]

    init(_ rootElement: IBElement) {
        _ = rootElement.browse { element in
            /// Manage identifiable
            if let identifiable = element as? IBIdentifiable {
                if let oldValue = byId[identifiable.id] {
                    duplicateId.append(oldValue)
                } else {
                    byId[identifiable.id] = identifiable
                }
            }
            /// Manage reusable
            if let identifiable = element as? IBReusable, let id = identifiable.reuseIdentifier {
                byResuseId[id] = identifiable
            }
            /// Manage by type
            let typeString = "\(type(of: element))"
            if byType[typeString] == nil {
                byType[typeString] = []
            }
            byType[typeString]?.append(element)
            
            return true
        }
  
    }
    
}
