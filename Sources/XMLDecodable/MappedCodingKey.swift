//
//  MappedCodingKey.swift
//  IBDecodable
//
//  Created by SaitoYuta on 2018/04/22.
//

import Foundation

struct MappedCodingKey: CodingKey {

    let stringValue: String
    var intValue: Int? { fatalError() }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        fatalError()
    }
}
