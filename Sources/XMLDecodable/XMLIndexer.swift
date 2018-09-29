//
//  XMLIndexer.swift
//  IBDecodable
//
//  Created by Yuta Saito on 2018/09/29.
//

protocol XMLIndexerType {
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K>
}
