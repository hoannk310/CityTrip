//
//  JsonDatabaseHelper.swift
//  SearchRepositories+Mvvm
//
//  Created by Tuấn Anh Nguyễn on 31/05/2022.
//

import Foundation

enum JsonFileType: String {
    
    case items
}

class JsonDatabaseHelper {
    
    static func loadJsonData(fileType: JsonFileType) -> [String: Any] {
        if let path = Bundle.main.path(forResource: fileType.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: Any] {
                    return jsonResult
                }
                return [:]
            } catch {
                return [:]
            }
        }
        return [:]
    }
    
    static func getJsonDataAtIndex(index: Int, jsonDictParent: [String: Any]) -> [String: Any] {
        let firstKey = Array(jsonDictParent.keys)[0]
        return jsonDictParent[firstKey] as! [String : Any]
    }
    
//    static func getItemsList(jsonDict: [String: Any]) -> ItemDotaListModel {
//        var itemsList: [ItemDotaModel] = []
//        loadJsonData(fileType: .items).keys.forEach {
//            let itemsDict = jsonDict[$0] as? [String: Any]
//            let item = try! JSONDecoder().decode(ItemDotaModel.self, from: JSONSerialization.data(withJSONObject: itemsDict, options: []))
//            itemsList.append(item)
//        }
//        var itemDotaListModel = ItemDotaListModel()
//        itemDotaListModel.itemsDota = itemsList
//        return itemDotaListModel
//    }
}
