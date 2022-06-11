//
//  GetPlacesRequest.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import Foundation
import Alamofire

struct GetPlacesLatLonRequest: NetworkRequest {
    var path: String { "geoname" }
    
    var method: String {
        HTTPMethod.get.rawValue
    }
    
    var parameters: [String : Any]? {
        ["name": name,
         "apikey": apiValue]
    }
    var name: String
}

struct GetPlacesRequest: NetworkRequest {
    var path: String { "radius" }
    
    var method: String {
        HTTPMethod.get.rawValue
    }
    
    var parameters: [String : Any]? {
        ["radius": 10000,
         "apikey": apiValue,
         "format": "json",
         "lat": lat,
         "lon": lon]
    }
    var lat: Double
    var lon: Double
}

struct Place: Codable {
    var xid: String
    var name: String?
    var dist: Double?
    var rate: Int?
    var osm: String?
    var kinds: String?
    var point: Point?
}

struct Point: Codable {
    var lat: Double?
    var lon: Double?
}
