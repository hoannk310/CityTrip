//
//  DataManagerRealm.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 3/4/21.
//

import Foundation
import RealmSwift

class DataManagerRealm {
    
    private var database: Realm
    
    init() {
        database = try! Realm()
    }
    
//    func getAllItem() -> [Favorite] {
//        let result = database.objects(Favorite.self).toArray(ofType: Favorite.self) as [Favorite]
//        return result
//    }
//    
//    func addData(object:Favorite){
//        try! database.write{
//            database.add(object)
//        }
//    }
//    
//    func deleteItemFromDB(object: Favorite) -> Bool {
//        do {
//            try database.write{
//                database.delete(object)
//            }
//            return true
//        } catch {
//            return false
//        }
//    }
    
    func deleteAllFromDB() -> Bool {
        do {
            try database.write{
                database.deleteAll()
            }
            return true
        } catch {
            return false
        }
    }
    
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
 
        return array
    }
}
