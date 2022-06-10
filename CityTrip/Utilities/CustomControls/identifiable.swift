//
//  identifiable.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 2/23/21.
//

import Foundation
protocol Identifiable {
    var identifier: String { get }
    
    static var identifier: String { get }
}

extension Identifiable {
    var identifier : String {
        return Self.identifier
    }
    
    static var identifier : String{
        return String (describing: self)
    }
}
