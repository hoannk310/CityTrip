//
//  PostCitiesRequest.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import Foundation
import Alamofire

struct PostCitiesRequest: NetworkRequest {
    var path: String { "countries/cities" }
    
    var method: String {
        HTTPMethod.post.rawValue
    }
    
    var country: String
    
    var body: BodyRequest? {
        DefaultBodyRequest(data: ["country": country],
                           encoding: NetworkUtil.JSON_ENCODING)
    }
}
