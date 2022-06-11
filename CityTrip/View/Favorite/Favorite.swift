//
//  Favorite.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import Foundation
import RealmSwift

class Favorite: Object {
    @objc dynamic var xid: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var dist: Double = 0.0
    @objc dynamic var rate: Int = 0
    @objc dynamic var osm: String = ""
    @objc dynamic var kinds: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var lon: Double = 0
    
    init(xid: String, name: String, dist: Double, rate: Int, osm: String, kinds: String, lat: Double, lon: Double) {
        self.xid = xid
        self.name = name
        self.dist = dist
        self.rate = rate
        self.osm = osm
        self.kinds = kinds
        self.lat = lat
        self.lon = lon
    }
    override init(){}
}
