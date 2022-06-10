//
//  ResponseObject.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 2/23/21.
//

import Foundation

final class ResponseObject: NSObject {
    
    var errorCode: Int = -1
    var httpCode: Int?
    var jsonString: String?
    var data: Data?
    var message: String?
    var error: Error?
}
