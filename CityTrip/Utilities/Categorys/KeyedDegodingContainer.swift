//
//  KeyedDegodingContainer.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 2/23/21.
//

import Foundation

extension KeyedDecodingContainer {
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, assignTo variable: inout T) where T: Decodable {
        if let value = try? decodeIfPresent(type.self, forKey: key) {
            variable = value
        }
    }
}
